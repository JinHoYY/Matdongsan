package com.project.alarm.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*
    SseEmitter(Spring)

    subscriber -> 1) 부동산 찜한 사용자, 2) 자유게시판 게시자, 3) 1:1채팅 이용하는 사용자, 4) 관리자
    Trigger  1) 부동산 찜할때 해제할 때 / 관심지역구에 해당하는 부동산 정보가 업데이트 되면 알림(*개 업데이트 됐습니다 형식)
             2) 내 글에 댓글 달릴 때
             3) 1:1 채팅 관리자 답변이 왔을 때
             4) 관리자에게 새로은 1:1문의(채팅방이 생성) 왔을 때

    1. 사용자는 로그인하면 sse 연결을 통해 실시간 알림을 받음
    2. 각 도메인 로직에서 alarm trigger 가 발생하면 -> db ALARM 테이블에 row 추가
                                            -> sse 통해 event 발생 (MEMBER_NO)
    3. sse 를 통해 알림을 받는면 사용자는 본인의 MEMBER_NO와 비교 -> 같으면 ajax 로 ALARM 을 읽어와 갱신
 */

@Slf4j
@Service
public class AlarmEventProducer {

    private final Map<Long, List<SseEmitter>> subscribers;
    // Long : MemberNo , List<SseEmitter> : 구독 리스트

    public AlarmEventProducer() {
        this.subscribers = new HashMap<>();
    }

    // send는 떠넘기기
    public void produce(long memberNo) {
        log.info("프로듀싱 정보 : " + memberNo);
    }

    public SseEmitter subscribe(long memberNo) {
        SseEmitter subscriber = new SseEmitter();
        subscriber.onCompletion(() -> subscribers.remove(memberNo));
        subscriber.onTimeout(() -> subscribers.remove(memberNo));

        if (subscribers.containsKey(memberNo)) {
            subscribers.get(memberNo).add(subscriber);
        } else {
            subscribers.put(memberNo, List.of(subscriber));
        }
        return subscriber;
    }

}