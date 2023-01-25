package com.project.realestate.dao;

import com.project.realestate.vo.RealEstateRent;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class RealEatateRentApiDao {
    private final SqlSessionTemplate sqlSession;

    public void truncateData() {
        sqlSession.delete("rentMapper.deleteAll");
    }

    public void packageInsert(List<RealEstateRent> houseList) {
        sqlSession.insert("rentMapper.packageInsert", houseList);
    }
}