package com.project.alarm.service;

import com.project.alarm.dao.AlarmDao;
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

    private final AlarmDao alarmDao;
    private final AlarmEventProducer alarmEventProducer;

    public List<Alarm> retrieveAlarmList(long memberNo) {
        return alarmDao.selectList(memberNo);
    }

    public void send(AlarmTemplate template) {
        // 1. template -> Alarm Entity 생성 -> alarmDao.save(entity)
        Alarm alarm = Alarm.of(template);
        alarmDao.save(alarm);

        // 2. alarmEventProducer.produce(memberNo)
        alarmEventProducer.produce(template.getMemberNo());
    }

}