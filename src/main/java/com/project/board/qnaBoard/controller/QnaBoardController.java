package com.project.board.qnaBoard.controller;

import org.springframework.stereotype.Controller;
import com.project.board.qnaBoard.vo.QnaBoard;
import com.project.board.qnaBoard.service.qnaBoardService;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class qnaBoardController {
    private qnaBoardService boardService;
 /*   @RequestMapping("/boardQnaMain")
   public QnaBoard selectBoardList(int bno) {
        QnaBoard b = qnaBoardService.selectBoardList(bno);
    }*/

}