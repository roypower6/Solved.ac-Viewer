# **solved_ac_viewer**

> **💡 solved.ac 사용자들을 위한 간편한 통계 조회 애플리케이션**

## **📱 소개**
solved.ac 비공식 API를 활용하여 개발된 애플리케이션으로, 웹 접속 없이도 편리하게 코딩 학습 현황을 다양한 지표로 확인할 수 있습니다.

**주의사항**: 본 앱은 개인이 제작한 비공식 앱으로, Baekjoon Online Judge 및 solved.ac와 직접적인 관련이 없습니다.

## **✨ 주요 기능**

### **1. 프로필 정보 조회**
<table width="100%">
  <tr>
    <td width="40%" align="center">
      <img src="https://github.com/user-attachments/assets/5aa73514-8980-44c6-a7a4-c271e2b13b64" width="200"/>
    </td>
    <td width="60%">
      <h4>💫 메인 프로필 화면</h4>
      <p>solved.ac 아이디 입력 후 표시되는 첫 화면입니다. 다음 정보를 한눈에 확인할 수 있습니다.</p>
      <ul>
        <li>사용자 배경 정보</li>
        <li>프로필 사진</li>
        <li>현재 티어</li>
        <li>최대 연속 문제 해결 일수</li>
      </ul>
    </td>
  </tr>
</table>

### **2. 메뉴 및 기능 네비게이션**
<table width="100%">
  <tr>
    <td width="40%" align="center">
      <img src="https://github.com/user-attachments/assets/5a691c4c-cca2-4714-9495-c85dd0f982c0" width="200"/>
    </td>
    <td width="60%">
      <h4>📱 슬라이드 메뉴</h4>
      <p>직관적인 사이드 메뉴를 통해 다양한 통계 기능에 쉽게 접근할 수 있습니다.</p>
      <ul>
      <p>메뉴 목록</p>
      <li>Home</li>
      <li>문제풀이 통계</li>
      <li>문제 검색</li>
      <li>코인샵</li>
      <li>앱 정보</li>
      <li>로그아웃</li>
      </ul>
    </td>
  </tr>
</table>

### **3. 문제 해결 통계**
<table width="100%">
  <tr>
    <td width="40%" align="center">
      <img src="https://github.com/user-attachments/assets/18a6d365-ce9f-4c5b-9b62-7946049b0376" width="200"/>
    </td>
    <td width="60%">
      <h4>🏷️ 태그별 통계</h4>
      <p>알고리즘 유형별 문제 해결 현황을 확인할 수 있습니다.</p>
      <ul>
        <li>태그별 분포 도넛형 그래프</li>
        <li>구체적인 해결 문제 수 리스트(내림차순)</li>
      </ul>
    </td>
  </tr>
</table>

<table width="100%">
  <tr>
    <td width="40%" align="center">
      <img src="https://github.com/user-attachments/assets/f905d8ae-34d1-4a38-a2ca-612432230a2f" width="200"/>
    </td>
    <td width="60%">
      <h4>📊 난이도별 통계</h4>
      <p>문제 난이도별 해결 현황을 보여줍니다.</p>
      <ul>
        <li>난이도별 분포 도넛형 그래프</li>
        <li>구체적인 해결 문제 수 리스트(내림차순)</li>
      </ul>
    </td>
  </tr>
</table>

### **4. 클래스 진행도**
<table width="100%">
  <tr>
    <td width="40%" align="center">
      <img src="https://github.com/user-attachments/assets/0808f866-b88e-4d6b-9017-36de2dfe4830" width="200"/>
    </td>
    <td width="60%">
      <h4>📚 클래스별 진행도</h4>
      <p>solved.ac의 클래스 시스템 진행 상황을 추적합니다. 각 클래스 별로 퍼센트를 보여주어 본인의 현재 위치를 가늠할 수 있습니다. 완료된 클래스는 초록색으로 표시됩니다.</p>
      <ul>
        <li>진행 중인 클래스 전체 현황</li>
        <li>클래스별 에센셜 문제 진행도</li>
      </ul>
    </td>
  </tr>
</table>

### **5. 백준 문제번호 검색**
<table width="100%">
  <tr>
    <td width="40%" align="center">
      <img src="https://github.com/user-attachments/assets/75dc7c41-1463-4102-a9c8-d1ff29356f73" width="200"/>
    </td>
    <td width="60%">
      <h4>🔍 백준 문제번호 검색 화면</h4>
      <p>백준에 등록되어 있는 문제번호로 백준 문제를 검색하고 다음 정보를 확인할 수 있습니다.</p>
      <ul>
        <li>문제 제목</li>
        <li>난이도 티어</li>
        <li>해결한 사용자 수</li>
        <li>평균 시도 횟수</li>
        <li>관련 태그</li>
        <li>백준 문제 사이트 바로가기 버튼</li>
      </ul>
    </td>
  </tr>
</table>

### **6. 백준 문제이름 검색**
<table width="100%">
  <tr>
    <td width="40%" align="center">
      <img src="https://github.com/user-attachments/assets/d4936671-6825-4654-af04-4e05a62425c1" width="200"/>
    </td>
    <td width="60%">
      <h4>🔍 백준 문제이름 검색 화면</h4>
      <p>백준에 등록되어 있는 문제의 이름을 검색하여 검색 결과 리스트를 반환받을 수 있습니다. (최대 10개)
      <p>리스트 화면에서도 간단하게 이름, 번호, 문제 난이도 티어, 해결 유저 수를 알 수 있습니다.</p>
      </p>
    </td>
  </tr>
  <tr>
    <td width="40%" align="center">
      <img src="https://github.com/user-attachments/assets/f99f87b0-d7af-4fbf-aa6b-43c6d9b234e9" width="200"/>
    </td>
    <td width="60%">
      <h4>🔍 문제이름 검색 후 각 문제의 상세 정보 화면</h4>
      <p>리스트 중 자기가 원하는 문제를 클릭하면 화면처럼 상세 내용을 확인할 수 있습니다.</p>
      <ul>
        <li>문제 이름</li>
        <li>난이도 티어</li>
        <li>해결한 사용자 수</li>
        <li>평균 시도 횟수</li>
        <li>관련 태그</li>
        <li>백준 문제 사이트 바로가기 버튼</li>
      </ul>
    </td>
  </tr>
</table>

## **🔜 향후 업데이트 계획**
- [ ] 다크 모드 지원
- [ ] 문제 추천 기능
- [ ] 사용자 비교 기능

## **📝 라이선스**
이 프로젝트는 MIT 라이선스에 따라 배포됩니다.