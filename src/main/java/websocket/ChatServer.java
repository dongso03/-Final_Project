package websocket;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.server.ServerEndpoint;

import com.mysql.cj.Session;

@ServerEndpoint("/ChatingServer")
public class ChatServer {
	private static Set<Session> clients 
		= Collections.synchronizedSet(new HashSet<Session>());
	
//	@OnOpen // 클라이언트 접속 시 실행
//	public void onOpen(Session session) {
//		clients.add(session); // 세션 추가
//		System.out.println("웹소켓 연결:" + session.getId());
//	}
//	
//	@OnMessage // 메시지를 받으면 실행
//	public void onMessage(String message, Session session) throws IOException {
//		System.out.println("메시지 전송 : " + session.getId() + ":" + message);
//		synchronized (clients) {
//			for (Session c : clients) {
//				if (!c.equals(session)) {
//					// 단, 메시지를 보낸 클라이언트는 제외하고 전달
//					c.getBasicRemote().sendText(message);
//				}
//			}
//		}
//	}
//	
//	@OnClose // 클라이언트와의 연결이 끊기면 실행
//	public void onClose(Session session) {
//		clients.remove(session);
//		System.out.println("웹소켓 종료 : " + session.getId());
//	}
//	
//	@OnError
//	public void onError(Throwable e) {
//		System.out.println("에러 발생");
//		e.printStackTrace();
//	}
}
