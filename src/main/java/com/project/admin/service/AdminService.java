package com.project.admin.service;

import com.project.admin.dao.AdminDao;
import com.project.admin.dto.*;
import com.project.admin.vo.Admin;
import com.project.admin.vo.BrokerEnroll;
import com.project.board.vo.Report;
import com.project.common.template.PageInfoCombine;
import com.project.member.dao.MemberDao;
import com.project.member.vo.Member;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
@RequiredArgsConstructor
public class AdminService {

    private final AdminDao adminDao;
    private final MemberDao memberDao;
    private final SqlSession sqlSession;
    private static final int DEFAULT_RES_SIZE = 12;


    public int uListCount() {
        return 0;
    }

    public AdminListResponse selectUserList(AdminListRequest request) {
        int count = adminDao.uListCount(sqlSession);
        PageInfoCombine pageInfoCombine = new PageInfoCombine(count, request.getCurrentPage(), DEFAULT_RES_SIZE);
        List<Member> result = adminDao.selectUserList(sqlSession, pageInfoCombine);
        return new AdminListResponse(result, pageInfoCombine);
    }

    public int rListCount() {
        return 0;
    }


    public ReportListResponse selectReportList(AdminListRequest request) {
        int count = adminDao.rListCount(sqlSession);
        PageInfoCombine pageInfoCombine = new PageInfoCombine(count, request.getCurrentPage(), DEFAULT_RES_SIZE);
        List<Report> result = adminDao.selectReportList(sqlSession, pageInfoCombine);
        return new ReportListResponse(result, pageInfoCombine);
    }


    public int deleteQna(int fNo) {
        return adminDao.deleteQna(sqlSession, fNo);
    }

    public int deleteFree(int fNo) {
        return adminDao.deleteFree(sqlSession, fNo);
    }

    public int insertBlack(Admin ad) {
        return adminDao.insertBlack(sqlSession, ad);
    }

    public BrokerListResponse brokerList(int currentPage) {
        int count = adminDao.BrokerListCount(sqlSession);
        PageInfoCombine pageInfoCombine = new PageInfoCombine(count, currentPage, DEFAULT_RES_SIZE);
        List<BrokerEnroll> brokerEnrollList = adminDao.BrokerList(sqlSession, pageInfoCombine);
        return new BrokerListResponse(brokerEnrollList, pageInfoCombine);
    }

    public void ban(BanRequest req) {
        memberDao.updateBanPeriod(req.getMemberNo(), req.periodToLocalDateTime());
    }

}
