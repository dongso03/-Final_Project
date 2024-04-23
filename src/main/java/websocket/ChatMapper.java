package websocket;

import org.apache.ibatis.annotations.*;

import post.Post;
import user.User;

import java.util.List;

public interface ChatMapper {

    // 모든 메시지 저장(단체 채팅방)
    @Insert("INSERT INTO messages (post_id, sender_id, content, sent_at) " +
            "VALUES (#{postId}, #{senderId}, #{content}, #{sentAt})")
    void insertMessage(Message message);
    
    // 귓속말 메시지 저장(단체 채팅방)
    @Insert("INSERT INTO private_message (sender_id, receiver_id, pri_content, pri_sent_at) " +
            "VALUES (#{senderId}, #{receiverId}, #{priContent}, #{priSentAt})")
    void insertPrivateMessage(PrivateMessage privateMessage);

    // 단체 채팅방 입장
    @Insert("INSERT INTO conversations (post_id, writeuser_id, guestuser_id , roomInTime) " +
            "VALUES (#{post_id}, #{writeuser_id}, #{guestuser_id}, #{roomInTime})")
    void insertChatroom(Conversations conversations);
    
    // 채팅방 (아예)나가기
    @Delete("DELETE FROM conversations WHERE post_id = #{post_id} AND guestuser_id "
    		+ "= #{guestuser_id}")
    void deleteChatroom(Conversations conversations);
    
    // 중복검사
    @Select("SELECT * FROM conversations WHERE guestuser_id = #{guestuser_id} AND post_id = #{post_id}")
    Conversations getGIdByGId(@Param("guestuser_id") int guestuserId, @Param("post_id") int postId);
    
    // (특정)유저채팅목록
    @Results(id = "postResultMap", value = {
            @Result(property = "post_Id", column = "post_id"),
            @Result(property = "writeUser_Id", column = "writeuser_id"),
            @Result(property = "guestUser_Id", column = "guestuser_id"),
            @Result(property = "title", column = "title"),
            @Result(property = "content", column = "content"),
            @Result(property = "resistDate", column = "resist_date"),
            @Result(property = "expireDate", column = "expire_date"),
            @Result(property = "status", column = "status"),
            @Result(property = "place", column = "place"),
            @Result(property = "view", column = "view")
    })
    @Select("SELECT * FROM user_conversations WHERE guestuser_id = #{guestuser_id}")
    List<Post> getListByGId(@Param("guestuser_id") int guestuserId);
    
    // 채팅방에 있는 유저가 채팅창을 다시 열었을 때 이전 메시지 가져오기
    @Select("SELECT * FROM messages WHERE post_id = #{postId} ORDER BY sent_at ASC")
    List<Message> getChatMessagesForPost(int postId);
    
    // 귓속말 가져오기
    @Select("SELECT * FROM private_message " +
            "WHERE (sender_id = #{senderId} AND receiver_id = #{receiverId}) " +
            "ORDER BY pri_sent_at ASC")
    List<PrivateMessage> getPrivateMessages(@Param("senderId") int senderId, @Param("receiverId") int receiverId);

    
    
    @Select("SELECT messages.content, messages.sent_at, users.nickname AS senderNickname " +
            "FROM messages " +
            "JOIN users ON messages.sender_id = users.user_id " +
            "WHERE messages.post_id = #{postId}")
    List<MessageWithSenderNickname> getChatMessagesWithSenderNicknameForPost(@Param("postId") int postId);

    @Update("UPDATE conversations SET status = 1 WHERE post_id = #{post_id}")
    int updateconversationsStatus(@Param("post_id") int postId, @Param("status") int status);
}
