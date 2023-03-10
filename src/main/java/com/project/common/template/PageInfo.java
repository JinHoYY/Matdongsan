package com.project.common.template;

import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Component;

import com.project.common.template.Pagination;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Component
@AllArgsConstructor
@NoArgsConstructor
@Data
public class PageInfo{
    private int listCount;
    private int currentPage;
    private int pageLimit;
    private int boardLimit;
    private int maxPage;
    private int startPage;
    private int endPage;
}

// TODO: 페이지인포 컴바인으로 합치기