package com.project.restaurant.dto;

import com.project.common.template.PageInfoCombine;
import com.project.restaurant.vo.Restaurant;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RestaurantListResponse {
    private List<Restaurant> restaurantList;
    private PageInfoCombine pageInfoCombine;
}
