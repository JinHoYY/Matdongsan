package com.project.member.controller;

import com.project.board.dto.FreeBoardResponse;
import com.project.board.dto.QnaBoardResponse;
import com.project.common.template.PageInfo;
import com.project.common.template.Pagination;
import com.project.common.type.StateList;
import com.project.member.dto.*;
import com.project.member.service.MemberService;
import com.project.member.vo.Member;
import com.project.realestate.dto.RealEstateDetailDto;
import com.project.realestate.dto.RealEstateInterestRequest;
import com.project.realestate.vo.Interest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
public class MemberController {

    private final MemberService memberService;

    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    @RequestMapping("/myPage")
    public ModelAndView ListPaging(@RequestParam(value = "cpage", defaultValue = "1") int currentPage,
//                                   @RequestParam("estateNo") String estateNo,
                                   ModelAndView modelAndView, HttpSession session){
        Member m = (Member) session.getAttribute("loginUser");
        MyPageListRequest req = new MyPageListRequest(currentPage);
        MyPageListResponse resp = memberService.selectList(req, m);

//        RealEstateDetailDto realEstateDetailDto = memberService.realEstateDetail(estateNo);
//        modelAndView.addObject("realEstateDetail", realEstateDetailDto);

        modelAndView.addObject("selectAllBoardList", resp.getAllBoardList());
        modelAndView.addObject("interestList", memberService.getInterestList(m));
        modelAndView.addObject("pi", resp.getPageInfoCombine());
        modelAndView.setViewName("member/myPage");


        return modelAndView;
    }

    @RequestMapping(value = "/memberModify")
    public String memberModify(Model model){

        model.addAttribute("stateList", StateList.values());

        return "member/memberModify";
    }

    /**
     * 회원정보를 수정하면 회원등급 변경
     */
    @RequestMapping(value = "/updateMember")
    public String updateMember(HttpSession session, Model model, Member m) {
        int result = memberService.updateMember(m);
        if (result != 0) {
            Member updateMember = memberService.loginMember(m);

            session.setAttribute("loginUser", updateMember);
            model.addAttribute("alertMsg","회원정보 수정 성공");
            return "redirect:/myPage";
        } else {
            model.addAttribute("errorMsg", "회원정보 수정 실패");
            return "common/errorPage";
        }
    }

//    @GetMapping("/myPage/interest")
//    @ResponseBody
//    public ResponseEntity<Boolean> checkInterest(@RequestParam String estateNo, HttpSession session){
//        Member loginUser = (Member) session.getAttribute("loginUser");
//        if (loginUser == null) {
//            throw new RuntimeException("로그인 하고 오세용");
//        }
//        boolean isInterest = MemberService.checkInterest(estateNo, loginUser);
//        return ResponseEntity.ok(isInterest);
//    }

    @PostMapping("/myPage")
    @ResponseBody
    public ResponseEntity<Void> saveInterest(@RequestBody RealEstateInterestRequest req, HttpSession session){
        Member loginUser = (Member) session.getAttribute("loginUser");
        if(loginUser == null){
            throw  new RuntimeException("로그인 해라 ");
        }
        memberService.saveInterest(req, loginUser);
        return ResponseEntity.ok().build();
    }








    /**
     * 휴대폰 인증
     */
    @RequestMapping(value = "/phoneCheck", method = RequestMethod.GET)
    @ResponseBody
    public String sendSMS(@RequestParam("phone") String userPhoneNumber) {
        int randomNumber = (int)((Math.random()* (9999 - 1000 + 1)) + 1000);
        memberService.certifiedPhoneNumber(userPhoneNumber,randomNumber);
        return Integer.toString(randomNumber);
    }

}
