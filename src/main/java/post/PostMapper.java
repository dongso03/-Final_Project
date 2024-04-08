package post;
import org.apache.ibatis.annotations.*;

import user.User;

import java.util.List;
import java.util.Map;

public interface PostMapper {
    // 전체 조회
	@Select("SELECT * FROM posts")
    List<Post> getAllPosts();
	
	// 특정 게시문 조회
    @Select("SELECT * FROM posts WHERE post_id = #{post_Id}")
    Post getPostById(@Param("post_Id") int postId);
    
    // 특정 유저가 작성한 게시물 조회
    @Select("SELECT * FROM posts WHERE writeuser_id = #{writeuser_id}")
    List<Post> getUserPostList(@Param("writeuser_id") int writeuser_id);
    
    // 게시물 작성
    @Insert("INSERT INTO posts (title,content, writeuser_id,expiredate, resistdate) " +
            "VALUES (#{post.title}, #{post.content}, #{post.writeuser_id}, #{post.expiredate}, #{post.resistdate})")
    void createPost(@Param("post")Post post, @Param("user")User user);

    
    // 게시물 업데이트
    @Update("UPDATE posts " +
            "SET content = #{post.content}, " + " title = #{post.title}," +
            "resistdate = NOW(), expiredate = #{post.expireDate}, status = #{post.status} " +
            "WHERE post_id = #{post.postId}")
    void updatePost(@Param("post") Post post);

    // 게시물 삭제
    @Delete("DELETE FROM posts WHERE post_id = #{post_Id}")
    void deletePost(@Param("post_Id") int postId);
    
    // 페이징 처리를 위한 쿼리
    @Select("SELECT * FROM posts WHERE status = 0 LIMIT #{limit} OFFSET #{offset}")
	List<Post> getPage(Map<String, Integer> params);

    @Select("SELECT COUNT(*) FROM posts WHERE status = 0")
    int countAll();
    
}
    
