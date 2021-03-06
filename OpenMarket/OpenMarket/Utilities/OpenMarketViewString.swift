//
//  ItemListViewString.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/24.
//

enum ItemListViewString {
    static let soldOut = "품절"
    static let errorMessage = "오류가 발생했습니다."
    static let remainingQuantity = "잔여수량:"
}

enum ItemUploadViewString {
    static let navigationBarPostTitle = "상품 등록"
    static let navigationBarPatchTitle = "상품 수정"
    static let postDoneButtonTitle = "등록"
    static let patchDoneButtonTitle = "수정"
    static let selectButton = "선택"
    static let imageCountLimitMessage = "이미지를 최소 1개 이상 5개 이하로 선택해주세요."
    static let titleEmptyMessage = "제품명을 입력해주세요"
    static let currencyEmptyMessage = "화폐를 선택해주세요"
    static let priceEmptyMessage = "가격을 입력해주세요"
    static let stockEmptyMessage = "수량을 입력해주세요"
    static let passwordEmptyMessage = "비밀번호를 입력해주세요"
    static let descriptionEmptyMessage = "상세 설명을 입력해주세요"
    static let descriptionPlaceholder = "게시글 내용을 작성해주세요. (가품 및 판매금지품목은 게시가 제한될 수 있어요.)"
}

enum ItemDetailViewString {
    static let openMarketAppTitle = "오픈 마켓"
    static let deleteButtonTitle = "삭제"
    static let patchButtonTitle = "수정"
    static let cancelButtonTitle = "취소"
    static let okButtonTitle = "확인"
    static let deletAlertTitle = "해당 상품을 삭제하시겠습니까?"
    static let deleteAlertMessage = "한번 삭제한 상품은 되돌릴 수 없습니다"
    static let deleteAlertTextFieldPlaceholder = "등록할 때 입력한 비밀번호"
}
