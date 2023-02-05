package com.project.alarm.dto;

import com.project.alarm.type.AlarmType;
import lombok.AllArgsConstructor;
import lombok.Data;

/*
    어디서 보내는 알람인지 (어느 도메인(리소스) 에서 보내는 알람인지)
    부동산 찜, 관심구, 자유게시판, 1:1 문의 (채팅)
    AlarmType + TargetNo -> 이동시킬 리소스 찾기
 */

@Data
@AllArgsConstructor
public class AlarmTemplate {

    private long memberNo;
    private AlarmType alarmType;
    private String targetNo;
    private String title;
    private String contents;

    public AlarmTemplate(long memberNo) {
        this.memberNo = memberNo;
    }

    public static AlarmTemplate generateNewChatMessageTemplate(String roomNo, long receiverNo, String senderName) {
        AlarmTemplate template = new AlarmTemplate(receiverNo);
        if (receiverNo == 1) {
            template.setTitle("1:1 문의");
            template.setAlarmType(AlarmType.NEW_QUESTION);
            template.setContents(senderName + " 님의 1:1 문의가 도착했습니다.");
            template.setTargetNo(roomNo);
        } else {
            template.setTitle("1:1 문의 답변");
            template.setAlarmType(AlarmType.NEW_ANSWER);
            template.setContents("1:1 문의에 새로운 답변이 도착했습니다.");
            template.setTargetNo(roomNo);
        }
        return template;
    }

    public static AlarmTemplate generateNewReplyTemplate(long receiverNo) {
        AlarmTemplate template = new AlarmTemplate(receiverNo);
        template.setTitle("내글 알림");
        template.setAlarmType(AlarmType.NEW_REPLY);
        template.setContents("내글에 댓글이 달렸습니다.");
        return template;
    }

    public static AlarmTemplate generateNewEstateUpdate(long receiverNo) {
        AlarmTemplate template = new AlarmTemplate(receiverNo);
        template.setTitle("부동산 정보알림");
        template.setAlarmType(AlarmType.NEW_ESTATE);
        template.setContents("새로운 부동산 정보가 있습니다.");
        return template;
    }
}
