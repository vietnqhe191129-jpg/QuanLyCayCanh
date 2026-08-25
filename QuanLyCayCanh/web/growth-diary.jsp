<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Nhật Ký Phát Triển</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
        rel="stylesheet">

    <link
        href="${pageContext.request.contextPath}/css/growth-diary.css"
        rel="stylesheet">
</head>


<body>

<div class="container diary-page py-4 py-lg-5">


    <%-- =====================================================
         HEADER
         ===================================================== --%>

    <div class="diary-header">

        <div>

            <a href="${pageContext.request.contextPath}/Care"
               class="back-link">

                <i class="fa-solid fa-arrow-left"></i>
                Quay lại khu vườn

            </a>

            <h1>
                <i class="fa-solid fa-chart-line"></i>
                Nhật ký phát triển
            </h1>

            <p>
                Theo dõi hành trình phát triển của cây theo thời gian.
            </p>

        </div>


        <button type="button"
                class="btn btn-add-diary"
                data-bs-toggle="modal"
                data-bs-target="#addDiaryModal">

            <i class="fa-solid fa-plus me-1"></i>
            Thêm nhật ký

        </button>

    </div>



    <%-- =====================================================
         PLANT INFORMATION
         ===================================================== --%>

    <div class="plant-summary">

        <div class="plant-summary-icon">
            <i class="fa-solid fa-seedling"></i>
        </div>

        <div>

            <span class="plant-summary-label">
                Đang xem nhật ký của cây
            </span>

            <div class="plant-summary-value">
                Plant #${plantId}
            </div>

        </div>

    </div>



    <%-- =====================================================
         EMPTY STATE
         ===================================================== --%>

    <c:if test="${empty diaries}">

        <div class="diary-empty">

            <div class="diary-empty-icon">
                <i class="fa-solid fa-seedling"></i>
            </div>

            <h4>Chưa có nhật ký phát triển</h4>

            <p>
                Hãy ghi lại cột mốc đầu tiên để bắt đầu theo dõi
                quá trình phát triển của cây.
            </p>

            <button type="button"
                    class="btn btn-add-diary"
                    data-bs-toggle="modal"
                    data-bs-target="#addDiaryModal">

                <i class="fa-solid fa-plus me-1"></i>
                Thêm nhật ký đầu tiên

            </button>

        </div>

    </c:if>



    <%-- =====================================================
         TIMELINE
         ===================================================== --%>

    <c:if test="${not empty diaries}">

        <div class="timeline-heading">

            <div>
                <h4>Hành trình phát triển</h4>

                <p>
                    Các cột mốc được ghi lại theo thời gian
                </p>
            </div>

        </div>


        <div class="growth-timeline">

            <c:forEach var="diary"
                       items="${diaries}">

                <div class="timeline-item">


                    <%-- TIMELINE DOT --%>

                    <div class="timeline-marker">

                        <div class="timeline-dot">
                            <i class="fa-solid fa-leaf"></i>
                        </div>

                    </div>



                    <%-- CONTENT --%>

                    <div class="timeline-content">


                        <%-- DATE --%>

                        <div class="timeline-date">

                            <i class="fa-regular fa-calendar me-1"></i>

                            <fmt:formatDate
                                value="${diary.logDate}"
                                pattern="dd/MM/yyyy" />

                            <span class="timeline-time">

                                <fmt:formatDate
                                    value="${diary.logDate}"
                                    pattern="HH:mm" />

                            </span>

                        </div>



                        <%-- CARD --%>

                        <div class="diary-entry">


                            <%-- IMAGE --%>

                            <c:if test="${not empty diary.imageUrl}">

                                <div class="diary-image-wrapper">

                                    <img src="${diary.imageUrl}"
                                         class="diary-image"
                                         alt="Ảnh phát triển của cây">

                                </div>

                            </c:if>



                            <%-- ENTRY CONTENT --%>

                            <div class="diary-entry-body">


                                <%-- HEIGHT --%>

                                <c:if test="${diary.heightCm != null}">

                                    <div class="height-info">

                                        <div class="height-icon">
                                            <i class="fa-solid fa-ruler-vertical"></i>
                                        </div>

                                        <div>

                                            <span class="info-label">
                                                Chiều cao
                                            </span>

                                            <strong>
                                                ${diary.heightCm} cm
                                            </strong>

                                        </div>

                                    </div>

                                </c:if>



                                <%-- NOTE --%>

                                <div class="diary-note">

                                    <div class="note-label">
                                        Ghi chú
                                    </div>

                                    <p>

                                        <c:choose>

                                            <c:when test="${not empty diary.note}">
                                                ${diary.note}
                                            </c:when>

                                            <c:otherwise>
                                                Không có ghi chú cho cột mốc này.
                                            </c:otherwise>

                                        </c:choose>

                                    </p>

                                </div>



                                <%-- ACTIONS --%>

                                <div class="diary-actions">

                                    <a href="${pageContext.request.contextPath}/Diary?action=edit&diaryId=${diary.diaryId}"
                                       class="btn btn-edit-diary">

                                        <i class="fa-solid fa-pen"></i>
                                        Sửa

                                    </a>


                                    <form action="${pageContext.request.contextPath}/Diary"
                                          method="POST"
                                          onsubmit="return confirm('Bạn có chắc muốn xóa nhật ký này?');">

                                        <input type="hidden"
                                               name="action"
                                               value="delete">

                                        <input type="hidden"
                                               name="diaryId"
                                               value="${diary.diaryId}">

                                        <input type="hidden"
                                               name="plantId"
                                               value="${diary.plantId}">


                                        <button type="submit"
                                                class="btn btn-delete-diary">

                                            <i class="fa-solid fa-trash"></i>
                                            Xóa

                                        </button>

                                    </form>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>

            </c:forEach>

        </div>

    </c:if>

</div>



<%-- =========================================================
     ADD DIARY MODAL
     ========================================================= --%>

<div class="modal fade"
     id="addDiaryModal"
     tabindex="-1"
     aria-hidden="true">

    <div class="modal-dialog modal-dialog-centered">

        <div class="modal-content diary-modal">


            <div class="modal-header">

                <div>

                    <h5 class="modal-title">
                        <i class="fa-solid fa-seedling me-1"></i>
                        Thêm cột mốc mới
                    </h5>

                    <span>
                        Ghi lại sự phát triển của cây
                    </span>

                </div>


                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal">
                </button>

            </div>



            <form action="${pageContext.request.contextPath}/Diary"
                  method="POST">

                <div class="modal-body">

                    <input type="hidden"
                           name="plantId"
                           value="${plantId}">


                    <%-- HEIGHT --%>

                    <div class="mb-3">

                        <label class="form-label">
                            <i class="fa-solid fa-ruler-vertical me-1"></i>
                            Chiều cao
                        </label>


                        <div class="input-group">

                            <input type="number"
                                   step="0.1"
                                   min="0"
                                   name="heightCm"
                                   class="form-control"
                                   placeholder="VD: 35.5">

                            <span class="input-group-text">
                                cm
                            </span>

                        </div>

                    </div>



                    <%-- IMAGE --%>

                    <div class="mb-3">

                        <label class="form-label">
                            <i class="fa-regular fa-image me-1"></i>
                            URL ảnh
                        </label>

                        <input type="text"
                               name="imageUrl"
                               class="form-control"
                               placeholder="https://...">

                        <div class="form-text">
                            Thêm ảnh để dễ dàng so sánh sự phát triển
                            của cây theo thời gian.
                        </div>

                    </div>



                    <%-- NOTE --%>

                    <div>

                        <label class="form-label">
                            <i class="fa-regular fa-note-sticky me-1"></i>
                            Ghi chú
                        </label>

                        <textarea name="note"
                                  class="form-control"
                                  rows="4"
                                  placeholder="VD: Cây mọc thêm chồi mới, lá xanh hơn..."></textarea>

                    </div>

                </div>



                <div class="modal-footer">

                    <button type="button"
                            class="btn btn-light"
                            data-bs-dismiss="modal">
                        Hủy
                    </button>

                    <button type="submit"
                            class="btn btn-add-diary">

                        <i class="fa-solid fa-floppy-disk me-1"></i>
                        Lưu nhật ký

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>



<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>