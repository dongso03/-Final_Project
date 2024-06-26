package post;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;

import review.Review;
import review.ReviewMapper;
import review.ReviewService;
import user.User;
import user.UserService;
import util.ServletUtil;

@WebServlet(urlPatterns = { "/post/detail", "/post/addReview", "/post/getUserId", "/post/deleteReview/*", "/post/updateReview/*" })
public class PostDetailServlet extends HttpServlet {
	private PostService postService = new PostService();
	private UserService userService = new UserService();
	private ReviewService reviewService = new ReviewService();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// GET 요청을 처리합니다.
		
		request.getRequestDispatcher("/postdetail.jsp").forward(request, response);
		
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String requestURI = req.getRequestURI();
		User currentUser = (User) req.getSession().getAttribute("user");
		
		if (requestURI.endsWith("/post/detail")) {
			// 게시물 상세 정보 요청 처리
			int postId = Integer.parseInt(req.getParameter("post_Id"));
			Post post = postService.getPostById(postId);
			
			postService.increasePostViews(postId);
			List<PostWithGuestUserIdDTO> DTOList = postService.getPostsWithStatusAndGuestUserId();
			List<Integer>attendGuestIdList =  postService.getGuestUserIdByPostId(postId);
			Map<String, Object> responseMap = new HashMap<>();
			List<User> attendUserList = new ArrayList<User>();
			List<List<Review>> attendGuestReviewList = new ArrayList<List<Review>>();
			if(attendGuestIdList != null) {
				for(Integer i : attendGuestIdList) {
					attendUserList.add(userService.getUser(i));
				}
				//TODO: 유저 리뷰 테이블 생성하는게 퍼포먼스적으로 차이
				
				for(User u : attendUserList) {
					List<Review> reviews = new ArrayList<Review>(); 
					reviews = reviewService.findReviewsReceivedByUserId(u.getUser_id(), postId);
					attendGuestReviewList.add(reviews);
				}
			}
			System.out.println(attendGuestReviewList.toString());
			//TODO: 디비 이름 수정 필요, 포레인키 해제 필요, null 고민 필요
			
			User user = userService.getUser(post.getWriteUser_Id());
			String place = postService.getPlaceByPostId(postId);
			PostTag tag = postService.getPostTagbyPostId(postId);
			System.out.println("장소 : " + place);
			System.out.println("태그 : " + tag);
			req.getSession().setAttribute("DTOList", DTOList);
			
			// 게시물과 리뷰 목록을 함께 담아 JSON 형태로 응답합니다.
			responseMap.put("post", post);
			responseMap.put("user", user);
			responseMap.put("place", place);
			responseMap.put("tags", tag);
			responseMap.put("DTOList", DTOList);
			responseMap.put("attendUserList", attendUserList);
			responseMap.put("attendGuestReviewList", attendGuestReviewList);
			responseMap.put("currentUser", currentUser);
			req.getSession().setAttribute("post", post);
			// JSON 형태로 변환하여 응답합니다.
			ServletUtil.sendJsonBody(responseMap, resp);
		}
		else if (requestURI.endsWith("/post/getUserId")) {
			User user = (User) req.getSession().getAttribute("user");
			resp.setContentType("application/json");
			ObjectMapper mapper = new ObjectMapper();
			mapper.writeValue(resp.getWriter(), user);
		}
	}

	@Override
	protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String pathInfo = req.getPathInfo();
	    String[] pathParts = pathInfo.split("/");
	    String reviewId = pathParts[1];
		
	    reviewService.deleteReview(Integer.parseInt(reviewId));
	    resp.setStatus(HttpServletResponse.SC_OK);
	}

	@Override
	protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String pathInfo = req.getPathInfo();
	    String[] pathParts = pathInfo.split("/");
	    String reviewId = pathParts[1];
	    
	    String requestBody = ServletUtil.readBody(req);
	    
	 // JSON 데이터를 Review 객체로 변환
	    ObjectMapper mapper = new ObjectMapper();
	    Review review = mapper.readValue(requestBody, Review.class);
	    System.out.println(review);
	    reviewService.updateReview(review);
	    
	}
	
	
	
}
