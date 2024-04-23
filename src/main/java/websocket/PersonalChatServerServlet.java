package websocket;
import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.json.JSONObject;

import user.UserService;

@WebServlet("/person/personalChatWindow/*")
public class PersonalChatServerServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	UserService userService = new UserService();
        // 요청 파라미터에서 userId 가져오기
        int userId = Integer.parseInt(request.getParameter("userId"));

        String opponentNickname = userService.getNicknameById(userId);

        // 가져온 정보를 JSON 형식으로 응답합니다.
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("nickname", opponentNickname);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse.toString());
    }
}

