package com.project.board.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.project.board.dto.FreeBoardCountDto;
import com.project.board.dto.FreeBoardListRequest;
import com.project.board.dto.FreeBoardListResponse;
import com.project.board.service.FreeBoardService;
import com.project.board.vo.FreeBoard;
import com.project.board.vo.Reply;
import com.project.board.vo.Report;
import com.project.common.annotation.Permission;
import com.project.common.annotation.RequiredLogin;
import com.project.common.template.ViewCountUp;
import com.project.common.type.StateList;
import com.project.member.type.MemberGrade;
import com.project.member.vo.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
@SessionAttributes("loginUser")
@RequestMapping("/board")
public class FreeBoardController {

    private final FreeBoardService freeBoardService;

    @RequestMapping("/freeList")
    public ModelAndView selectFreeList(ModelAndView modelAndView,
                                       @RequestParam(value = "cpage", defaultValue = "1") int currentPage,
                                       @RequestParam(value = "state", defaultValue = "") String state,
                                       @RequestParam(value = "search", defaultValue = "") String search,
                                       @RequestParam(value = "select", defaultValue = "recent") String select
    ) {

        FreeBoardListRequest req = new FreeBoardListRequest(currentPage, state, search, select);
        FreeBoardListResponse resp = freeBoardService.selectFreeList(req);
        List<FreeBoard> freeNoticeList = freeBoardService.freeNoticeList();
        freeBoardService.selectReportList(); // ???????????? ????????? ?????? ??? ????????????

        System.out.println("???????????? check: " + freeNoticeList);

        modelAndView.addObject("freeBoardList", resp.getFreeBoardList());
        modelAndView.addObject("freeNoticeList", freeNoticeList);
        modelAndView.addObject("pi", resp.getPageInfoCombine());
        modelAndView.addObject("stateList", StateList.values());
        modelAndView.addObject("hotWeekList", freeBoardService.hotWeekList());
        modelAndView.addObject("condition", req);
        modelAndView.setViewName("board/freeBoardList");

        return modelAndView;
    }


    // ????????? ?????????
    @RequestMapping("/freeList/enrollForm")
    @RequiredLogin
    public String enrollForm(Model model) {
        model.addAttribute("localList", StateList.values());
        return "board/freeBoardEnroll";
    }

    // ????????? ??????
    @RequestMapping("freeList/insert")
    @RequiredLogin
    public String insertFreeBoard(@RequestParam(value = "boardWriter", defaultValue = "") String boardWriter,
                                  @RequestParam(value = "boardArea", defaultValue = "") String boardArea,
                                  Model model, FreeBoard fb, HttpSession session
    ) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser.getMemberNo() == 1) {
            model.addAttribute("boardWriter", boardWriter);
            freeBoardService.insertNotice(fb);
        } else {
            model.addAttribute("boardWrtier", boardWriter);
            freeBoardService.insertFboard(fb);
        }
        return "redirect:/board/freeList";
    }

    // ????????? ????????????
    @RequestMapping("freeList/detail/{fno}")
    public ModelAndView detailFreeBoard(ModelAndView mv,
                                        @PathVariable("fno") int fno,
                                        HttpServletRequest httpServletRequest,
                                        HttpServletResponse httpServletResponse,
                                        HttpSession session

    ) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        long memberNo = 0;

        if (!ObjectUtils.isEmpty(loginUser)) {
            memberNo = loginUser.getMemberNo();
        }

        FreeBoard fb = freeBoardService.detailFreeBoard(fno);
        if (fb == null) {
            mv.addObject("errorMsg", "????????? ??????????????????.");
            mv.setViewName("common/errorPage");
        } else {
            boolean countCheck = ViewCountUp.countUp(fb, memberNo, httpServletRequest, httpServletResponse);
            if (countCheck) {
                FreeBoardCountDto count = FreeBoardCountDto.count(fno, memberNo);
                freeBoardService.freeBoardCount(count);
            }
            mv.addObject("fb", fb);
            mv.setViewName("board/freeBoardDetail");
        }

        return mv;
    }

    // ????????? ??????
    @RequestMapping(value = "/update", produces = "application/json")
    @ResponseBody
    @RequiredLogin
    public ResponseEntity<FreeBoard> updatePost(FreeBoard freeBoard) throws Exception {
        freeBoardService.updatePost(freeBoard);
        freeBoard = freeBoardService.detailFreeBoard(freeBoard.getBoardNo());
        return ResponseEntity.ok(freeBoard);
    }

    // ????????? ??????
    @RequestMapping("freeList/deletePost={fno}")
    @RequiredLogin
    public String deletePost(@PathVariable("fno") int fno) {
        int result = freeBoardService.deletePost(fno);
        if (result == 0) {
            return "common/errorPage";
        } else {
            return "redirect:/board/freeList";
        }

    }

    // ?????? ??????
    @RequestMapping("/insertReply")
    @ResponseBody
    @RequiredLogin
    public String insertReply(Reply r, HttpSession session) {

        Member m = (Member) session.getAttribute("loginUser");
        if (m != null) {
            r.setMemberNo(m.getMemberNo());
        }
        int result = freeBoardService.insertReply(r);
        if (result > 0) {
            return "1";
        } else {
            return "0";
        }

    }

    // ?????? ??????
    @RequestMapping("/replyList")
    @ResponseBody
    public String selectReplyList(int fno) {
        ArrayList<Reply> replyList = freeBoardService.selectReplyList(fno);
        Gson gson = new GsonBuilder().create();
        String result = gson.toJson(replyList);
        return result;
    }

    // ?????? ??????
    @RequestMapping("/deleteReply")
    @ResponseBody
    public int deleteReply(Reply reply) {
        int result = freeBoardService.deleteReply(reply);
        return result;
    }

    // ????????? ????????????
    @RequestMapping("/report")
    @ResponseBody
    @RequiredLogin
    public String reportPost(Report report) {

        int result = freeBoardService.insertReport(report);
        if (result > 0) {
            return "1";
        } else {
            return "0";
        }
    }

}
