package com.project.member.dto;

import lombok.*;

@Getter
@AllArgsConstructor
public class MemberDto {

    private long memberNo;
    private String nickName;
    private String email;
    private String phone;
    private String address;
    private String provider;
    private String providerId;
    private String profileImage;
    private String interestState;
}
