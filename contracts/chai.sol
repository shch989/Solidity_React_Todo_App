// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// 이 줄은 Solidity 컴파일러 버전을 지정합니다. 이 스마트 계약은 0.7.0 이상 0.9.0 미만의 버전에서 동작합니다.

contract chai {
    // "chai"라는 스마트 계약을 정의합니다.

    struct Memo {
        // Memo라는 구조체를 정의합니다.
        string name; // 메모의 이름을 저장하는 문자열 필드
        string message; // 메모 내용을 저장하는 문자열 필드
        uint timestamp; // 메모가 작성된 타임스탬프를 저장하는 정수 필드
        address from; // 메모를 작성한 주소를 저장하는 필드
    }

    Memo[] memos; // Memo 구조체의 배열을 선언하여 메모들을 저장합니다.

    address payable owner;

    // owner 변수는 이 스마트 계약의 소유자 주소를 저장합니다. payable 키워드는 이 주소가 이더리움을 받을 수 있는 주소임을 나타냅니다.

    constructor() {
        // 생성자 함수입니다. 스마트 계약이 배포될 때 실행됩니다.
        owner = payable(msg.sender);
        // owner 변수를 스마트 계약을 배포한 주소(msg.sender)로 초기화합니다.
    }

    function buyChai(
        string calldata name,
        string calldata message
    ) external payable {
        // buyChai 함수는 이더를 송금하고 메모를 작성하는데 사용됩니다.
        require(msg.value > 0, 'Please pay more than 0 ether');
        // 이더를 송금하는데 0보다 큰 값이 전달되었는지 확인합니다. 그렇지 않다면 에러 메시지를 표시합니다.

        owner.transfer(msg.value);
        // 송금된 이더를 계약의 소유자에게 전송합니다.

        memos.push(Memo(name, message, block.timestamp, msg.sender));
        // 새로운 메모를 memos 배열에 추가합니다. 메모의 이름, 내용, 타임스탬프 및 작성자 주소를 저장합니다.
    }

    function getMemos() public view returns (Memo[] memory) {
        // getMemos 함수는 저장된 모든 메모를 조회하기 위한 함수입니다.
        return memos;
        // memos 배열의 모든 메모를 반환합니다. "memory" 키워드는 반환 값이 메모리에 저장된다는 것을 나타냅니다.
    }
}
