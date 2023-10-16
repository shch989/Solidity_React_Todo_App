// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CloudFunding {
    struct Campaign {
        address owner; // 캠페인 소유자 주소
        string title; // 캠페인 제목
        string description; // 캠페인 설명
        uint256 target; // 목표 금액
        uint256 deadline; // 마감 일자 (UNIX 타임스탬프)
        uint256 amountCollected; // 현재까지 모인 금액
        string image; // 캠페인 이미지 URL
        address[] donators; // 기부자 주소 배열
        uint256[] donations; // 각 기부 금액 배열
    }

    mapping(uint256 => Campaign) public campaigns; // 캠페인 정보를 저장하는 맵
    uint256 public numberOfCampaigns = 0; // 생성된 캠페인 수

    // 새로운 캠페인을 생성하는 함수
    function createCampaign(
        address _owner, // 소유자 주소
        string memory _title, // 제목
        string memory _description, // 설명
        uint256 _target, // 목표 금액
        uint256 _deadline, // 마감 일자
        string memory _image // 이미지 URL
    ) public returns (uint256) {
        // 캠페인 구조체를 생성하고 해당 인덱스로 접근
        Campaign storage campaign = campaigns[numberOfCampaigns];

        // 마감일이 현재 시간 이전인 경우 예외를 발생시킴
        require(
            _deadline > block.timestamp,
            'The deadline should be a date in the future.'
        );

        // 캠페인 정보를 설정
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        // 생성된 캠페인 수를 증가
        numberOfCampaigns++;

        // 새로운 캠페인의 인덱스 반환
        return numberOfCampaigns - 1;
    }

    // 캠페인에 기부하는 함수
    function donateToCampaign(uint256 _id) public payable {
        // 메시지의 Ether 값 저장
        uint256 amount = msg.value;

        // 주어진 캠페인 ID를 사용하여 캠페인 구조체에 접근
        Campaign storage campaign = campaigns[_id];

        // 메시지 발신자 (기부자)의 주소를 캠페인의 기부자 목록에 추가
        campaign.donators.push(msg.sender);

        // 기부 금액을 캠페인의 기부 금액 목록에 추가
        campaign.donations.push(amount);

        // 캠페인 소유자에게 Ether를 전송
        (bool sent, ) = payable(campaign.owner).call{value: amount}('');

        // Ether 전송이 성공한 경우
        if (sent) {
            // 캠페인의 총 모금액을 증가
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    // 특정 캠페인의 기부자 목록 및 기부 금액을 조회하는 함수
    function getDonators(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        // 주어진 캠페인 ID를 사용하여 해당 캠페인의 기부자 목록과 기부 금액을 반환
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

}
