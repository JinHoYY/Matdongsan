package com.project.alarm.service;

import com.project.alarm.repository.AlarmRepository;
import com.project.alarm.dto.AlarmTemplate;
import com.project.alarm.vo.Alarm;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class AlarmService {

    private final AlarmRepository alarmRepository;
    private final AlarmEventProducer alarmEventProducer;

    public List<Alarm> retrieveAlarmList(long memberNo) {
        return alarmRepository.selectList(memberNo);
    }

    /*
        MemberNo 00에게 새로운 알람왔다 라고만 알려주면 00이 직접 읽어야함 -> Zero Payload 방식
        테이블에 알람을 쌓고 있음
        보내기전에 db에 기록을 해줘야하니까 알람 서비스가 필요 하고 서비스한테 send 해달라고 하면 기록하고 보냄
     */
    public void send(AlarmTemplate template) {
        // 1. template -> Alarm Entity 생성 -> alarmDao.save(entity)
        Alarm alarm = Alarm.of(template);
        alarmRepository.save(alarm);
        // 2. alarmEventProducer.produce(memberNo)
        alarmEventProducer.produceAlarm(template.getMemberNo());
    }

    public Alarm read(long alarmNo) {
        alarmRepository.read(alarmNo);
        return alarmRepository.selectByAlarmNo(alarmNo);
    }

    public void readAll(long memberNo) {
        alarmRepository.readAll(memberNo);
    }

    public void delete(long alarmNo) {
        alarmRepository.delete(alarmNo);
    }

    public void deleteIfRead(long memberNo) {
        alarmRepository.deleteIfRead(memberNo);
    }
}
