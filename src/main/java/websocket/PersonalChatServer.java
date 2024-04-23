package websocket;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@ServerEndpoint("/PersonalChatWindow/{userid}")
public class PersonalChatServer {
    // 사용자 세션 관리를 위한 Map
    private static Map<String, Session> sessions = new HashMap<>();

    @OnOpen
    public void onOpen(Session session) {
        // 연결된 클라이언트의 세션을 Map에 추가
        String userId = getUserIdFromSession(session);
        if (userId != null) {
            sessions.put(userId, session);
        } else {
            try {
                session.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @OnClose
    public void onClose(Session session) {
        // 연결이 종료된 클라이언트의 세션을 Map에서 제거
        String userId = getUserIdFromSession(session);
        if (userId != null) {
            sessions.remove(userId);
        }
    }

    @OnError
    public void onError(Throwable error) {
        // 에러 처리
        error.printStackTrace();
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        // 클라이언트로부터 메시지를 받았을 때 처리
        // 이 예제에서는 클라이언트로부터의 메시지를 그대로 다시 보냄
        String userId = getUserIdFromSession(session);
        if (userId != null) {
            // 상대방의 userId를 추출하여 해당 세션으로 메시지 전송
            String recipientUserId = extractRecipientUserIdFromMessage(message);
            Session recipientSession = sessions.get(recipientUserId);
            if (recipientSession != null) {
                try {
                    recipientSession.getBasicRemote().sendText(message);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private String getUserIdFromSession(Session session) {
        // 세션에서 userId를 추출하는 메서드
        // 여기서는 세션의 파라미터에서 userId를 추출하여 반환
        Map<String, String> pathParameters = session.getPathParameters();
        return pathParameters.get("userid");
    }

    private String extractRecipientUserIdFromMessage(String message) {
        // 메시지에서 수신자의 userId를 추출하는 메서드
        // 여기서는 JSON 형식의 메시지에서 'recipient' 필드를 추출하여 반환
        // 실제로는 클라이언트 측에서 어떻게 메시지를 구성하는지에 따라 이 부분을 수정해야 할 수 있음
        // 예: {"sender":"John","recipient":"Alice","content":"Hello"}
        // 위와 같이 sender와 recipient이라는 필드가 있는 경우
        // 여기서는 추출하는 방법을 변경해야 함
        return null; // 일단 null 반환하고, 클라이언트에서의 메시지 구조에 따라 수정 필요
    }
}
