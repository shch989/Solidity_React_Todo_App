// Hardhat 라이브러리를 가져옵니다.
const hre = require('hardhat')

// 비동기 함수 main을 정의합니다.
async function main() {
  // 'chai' 스마트 계약의 팩토리(클래스)를 가져옵니다.
  const Chai = await hre.ethers.getContractFactory('chai')

  // 'chai' 팩토리를 사용하여 새로운 'chai' 스마트 계약 인스턴스를 배포합니다.
  const chai = await Chai.deploy()

  // 스마트 계약이 배포되었을 때까지 대기합니다.
  await chai.deployed()

  // 배포된 스마트 계약의 주소를 콘솔에 출력합니다.
  console.log('Deployed contract address:', `${chai.address}`)
}

// main 함수를 호출하여 스마트 계약을 배포하고 주소를 출력합니다.
main().catch((error) => {
  // 코드 실행 중에 오류가 발생하면 오류를 콘솔에 출력하고 프로세스 종료 코드를 1로 설정하여 오류 상태를 표시합니다.
  console.error(error)
  process.exitCode = 1
})
