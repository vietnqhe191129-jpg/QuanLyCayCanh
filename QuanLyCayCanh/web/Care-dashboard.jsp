<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>

<html lang="vi">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Chăm Sóc Cây</title>


    <!-- Bootstrap -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- Font Awesome -->

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
        rel="stylesheet">


    <!-- Custom CSS -->

    <link
        href="${pageContext.request.contextPath}/css/user.css"
        rel="stylesheet">

</head>


<body>


<div class="container page-shell py-4 py-lg-5">


    <%-- =====================================================
         HEADER
         ===================================================== --%>

    <div class="d-flex
                flex-column
                flex-md-row
                justify-content-between
                align-items-md-center
                gap-3
                mb-4">


        <div class="page-heading">

            <h1>

                <i class="fa-solid fa-seedling text-success me-2"></i>

                Khu vườn của tôi

            </h1>


            <p>

                Theo dõi tình trạng và lịch chăm sóc cây cảnh của bạn.

            </p>

        </div>


        <div class="top-actions">


            <a href="${pageContext.request.contextPath}/TodayTask"
               class="btn btn-outline-success">

                <i class="fa-solid fa-list-check me-1"></i>

                Việc hôm nay

            </a>


            <a href="${pageContext.request.contextPath}/add-plant"
               class="btn btn-primary-app">

                <i class="fa-solid fa-plus me-1"></i>

                Thêm cây

            </a>


        </div>


    </div>



    <%-- =====================================================
         SUMMARY
         ===================================================== --%>

    <div class="row g-3 mb-5">


        <%-- Tổng số cây --%>

        <div class="col-md-4">

            <div class="summary-card">


                <div class="summary-icon green">

                    <i class="fa-solid fa-seedling"></i>

                </div>


                <div class="summary-value">

                    ${fn:length(plants)}

                </div>


                <div class="summary-label">

                    Tổng số cây

                </div>


            </div>

        </div>



        <%-- Cây có lịch tưới --%>

        <div class="col-md-4">

            <div class="summary-card">


                <div class="summary-icon blue">

                    <i class="fa-solid fa-droplet"></i>

                </div>


                <div class="summary-value">


                    <c:set var="scheduleCount"
                           value="0" />


                    <c:forEach var="summaryPlant"
                               items="${plants}">


                        <c:set var="summarySchedule"
                               value="${scheduleMap[summaryPlant.plantId]}" />


                        <c:if test="${summarySchedule != null}">

                            <c:set var="scheduleCount"
                                   value="${scheduleCount + 1}" />

                        </c:if>


                    </c:forEach>


                    ${scheduleCount}


                </div>


                <div class="summary-label">

                    Cây có lịch tưới

                </div>


            </div>

        </div>



        <%-- Cây cần chú ý --%>

        <div class="col-md-4">

            <div class="summary-card">


                <div class="summary-icon red">

                    <i class="fa-solid fa-triangle-exclamation"></i>

                </div>


                <div class="summary-value">


                    <c:set var="warningCount"
                           value="0" />


                    <c:forEach var="summaryPlant"
                               items="${plants}">


                        <c:if test="${summaryPlant.healthStatus ne 'Khỏe mạnh'}">

                            <c:set var="warningCount"
                                   value="${warningCount + 1}" />

                        </c:if>


                    </c:forEach>


                    ${warningCount}


                </div>


                <div class="summary-label">

                    Cây cần chú ý

                </div>


            </div>

        </div>


    </div>



    <%-- =====================================================
         SECTION HEADER
         ===================================================== --%>

    <div class="section-header mb-3">


        <div class="section-title">

            Cây của tôi

        </div>


        <div class="text-muted">

            Chọn một cây để xem chi tiết.

        </div>


    </div>



    <%-- =====================================================
         EMPTY STATE
         ===================================================== --%>

    <c:if test="${empty plants}">


        <div class="empty-state">


            <div class="empty-state-icon">

                <i class="fa-solid fa-seedling"></i>

            </div>


            <h4>

                Khu vườn đang trống

            </h4>


            <p class="text-muted mb-4">

                Thêm cây đầu tiên để bắt đầu theo dõi và chăm sóc.

            </p>


            <a href="${pageContext.request.contextPath}/add-plant"
               class="btn btn-primary-app">

                <i class="fa-solid fa-plus me-1"></i>

                Thêm cây đầu tiên

            </a>


        </div>


    </c:if>



    <%-- =====================================================
         PLANT LIST
         ===================================================== --%>

    <c:if test="${not empty plants}">


        <div class="row g-4">


            <c:forEach var="plant"
                       items="${plants}">


                <%-- Schedule WATER của cây --%>

                <c:set var="schedule"
                       value="${scheduleMap[plant.plantId]}" />


                <%-- Trạng thái tưới --%>

                <c:set var="waterStatus"
                       value="${waterStatusMap[plant.plantId]}" />


                <%-- Số ngày tới lần tưới --%>

                <c:set var="daysUntilWater"
                       value="${daysUntilWaterMap[plant.plantId]}" />



                <div class="col-sm-6 col-lg-4 col-xl-3">


                    <div class="plant-card"
                         data-bs-toggle="modal"
                         data-bs-target="#plantModal${plant.plantId}">



                        <%-- =====================================================
                             IMAGE
                             ===================================================== --%>

                        <div class="plant-image-wrapper">


                            <c:choose>


                                <c:when test="${not empty plant.imageUrl}">

                                    <img
                                        src="${plant.imageUrl}"
                                        class="plant-img"
                                        alt="${plant.customName}">

                                </c:when>


                                <c:otherwise>

                                    <div class="plant-image-placeholder">

                                        <i class="fa-solid fa-seedling"></i>

                                    </div>

                                </c:otherwise>


                            </c:choose>



                            <%-- HEALTH BADGE --%>

                            <c:choose>


                                <c:when test="${plant.healthStatus eq 'Khỏe mạnh'}">

                                    <span class="health-badge health-healthy">

                                        <i class="fa-solid fa-circle-check me-1"></i>

                                        Khỏe mạnh

                                    </span>

                                </c:when>


                                <c:when test="${plant.healthStatus eq 'Cần chăm sóc'}">

                                    <span class="health-badge health-warning">

                                        <i class="fa-solid fa-triangle-exclamation me-1"></i>

                                        Cần chăm sóc

                                    </span>

                                </c:when>


                                <c:otherwise>

                                    <span class="health-badge health-sick">

                                        <i class="fa-solid fa-circle-exclamation me-1"></i>

                                        ${plant.healthStatus}

                                    </span>

                                </c:otherwise>


                            </c:choose>


                        </div>



                        <%-- =====================================================
                             CARD BODY
                             ===================================================== --%>

                        <div class="plant-card-body">


                            <div>


                                <div class="plant-name">

                                    ${plant.customName}

                                </div>


                                <div class="plant-location">

                                    <i class="fa-solid fa-location-dot me-1"></i>


                                    <c:choose>


                                        <c:when test="${not empty plant.locationInHome}">

                                            ${plant.locationInHome}

                                        </c:when>


                                        <c:otherwise>

                                            Chưa thiết lập vị trí

                                        </c:otherwise>


                                    </c:choose>


                                </div>


                            </div>



                            <%-- =====================================================
                                 CARE INFO
                                 ===================================================== --%>

                            <div class="care-box">


                                <c:choose>


                                    <%-- Không có lịch --%>

                                    <c:when test="${schedule == null}">


                                        <div class="care-label">

                                            Lịch tưới

                                        </div>


                                        <div class="care-value text-muted">

                                            <i class="fa-regular fa-calendar-xmark me-1"></i>

                                            Chưa thiết lập

                                        </div>


                                    </c:when>



                                    <%-- Có lịch --%>

                                    <c:otherwise>


                                        <div class="care-label">

                                            Lịch tưới tiếp theo

                                        </div>


                                        <div class="care-main-row">


                                            <div class="care-value">


                                                <i class="fa-solid
                                                          fa-droplet
                                                          text-primary
                                                          me-1"></i>


                                                <c:choose>


                                                    <c:when test="${schedule.nextDueDate != null}">


                                                        <fmt:formatDate
                                                            value="${schedule.nextDueDate}"
                                                            pattern="dd/MM/yyyy" />


                                                    </c:when>


                                                    <c:otherwise>

                                                        Chưa thiết lập

                                                    </c:otherwise>


                                                </c:choose>


                                            </div>



                                            <%-- Upcoming --%>

                                            <c:if test="${waterStatus eq 'UPCOMING'}">


                                                <span class="water-days-left">


                                                    <i class="fa-regular fa-clock me-1"></i>


                                                    <c:choose>


                                                        <c:when test="${daysUntilWater == 1}">

                                                            Ngày mai

                                                        </c:when>


                                                        <c:otherwise>

                                                            Còn ${daysUntilWater} ngày

                                                        </c:otherwise>


                                                    </c:choose>


                                                </span>


                                            </c:if>



                                            <%-- Today --%>

                                            <c:if test="${waterStatus eq 'TODAY'}">


                                                <span class="water-status today-status">

                                                    Hôm nay

                                                </span>


                                            </c:if>



                                            <%-- Overdue --%>

                                            <c:if test="${waterStatus eq 'OVERDUE'}">


                                                <span class="water-status overdue-status">

                                                    Quá hạn

                                                </span>


                                            </c:if>


                                        </div>


                                    </c:otherwise>


                                </c:choose>


                            </div>



                            <%-- =====================================================
                                 ACTION
                                 ===================================================== --%>

                            <div class="plant-action">


                                <c:choose>



                                    <%-- OVERDUE --%>

                                    <c:when test="${waterStatus eq 'OVERDUE'}">


                                        <form
                                            action="${pageContext.request.contextPath}/CareLog"
                                            method="POST"
                                            onclick="event.stopPropagation();">


                                            <input
                                                type="hidden"
                                                name="scheduleId"
                                                value="${schedule.scheduleId}">


                                            <input
                                                type="hidden"
                                                name="plantId"
                                                value="${plant.plantId}">


                                            <input
                                                type="hidden"
                                                name="actionType"
                                                value="WATER">


                                            <button
                                                type="submit"
                                                class="btn btn-danger w-100">

                                                <i class="fa-solid fa-droplet me-1"></i>

                                                Tưới ngay

                                            </button>


                                        </form>


                                    </c:when>



                                    <%-- TODAY --%>

                                    <c:when test="${waterStatus eq 'TODAY'}">


                                        <form
                                            action="${pageContext.request.contextPath}/CareLog"
                                            method="POST"
                                            onclick="event.stopPropagation();">


                                            <input
                                                type="hidden"
                                                name="scheduleId"
                                                value="${schedule.scheduleId}">


                                            <input
                                                type="hidden"
                                                name="plantId"
                                                value="${plant.plantId}">


                                            <input
                                                type="hidden"
                                                name="actionType"
                                                value="WATER">


                                            <button
                                                type="submit"
                                                class="btn btn-primary-app w-100">

                                                <i class="fa-solid fa-droplet me-1"></i>

                                                Tưới hôm nay

                                            </button>


                                        </form>


                                    </c:when>


                                </c:choose>


                            </div>


                        </div>


                    </div>


                </div>



                <%-- =====================================================
                     MODAL
                     ===================================================== --%>

                <div class="modal fade"
                     id="plantModal${plant.plantId}"
                     tabindex="-1"
                     aria-hidden="true">


                    <div class="modal-dialog
                                modal-lg
                                modal-dialog-centered">


                        <div class="modal-content">



                            <%-- HEADER --%>

                            <div class="modal-header">


                                <div>


                                    <h5 class="modal-title fw-bold mb-1">

                                        ${plant.customName}

                                    </h5>


                                    <span class="text-muted small">

                                        Chi tiết và chăm sóc cây

                                    </span>


                                </div>


                                <button
                                    type="button"
                                    class="btn-close"
                                    data-bs-dismiss="modal"
                                    aria-label="Close">
                                </button>


                            </div>



                            <%-- BODY --%>

                            <div class="modal-body p-4">


                                <div class="row g-4">



                                    <%-- IMAGE --%>

                                    <div class="col-md-5">


                                        <c:choose>


                                            <c:when test="${not empty plant.imageUrl}">

                                                <img
                                                    src="${plant.imageUrl}"
                                                    class="modal-plant-image"
                                                    alt="${plant.customName}">

                                            </c:when>


                                            <c:otherwise>

                                                <div class="modal-image-placeholder">

                                                    <i class="fa-solid fa-seedling"></i>

                                                </div>

                                            </c:otherwise>


                                        </c:choose>


                                    </div>



                                    <%-- DETAILS --%>

                                    <div class="col-md-7">


                                        <div class="detail-section-title text-success">

                                            <i class="fa-solid fa-leaf me-1"></i>

                                            Thông tin cây

                                        </div>



                                        <div class="detail-row">


                                            <div class="detail-label">

                                                Vị trí

                                            </div>


                                            <div class="detail-value">


                                                <c:choose>


                                                    <c:when test="${not empty plant.locationInHome}">

                                                        ${plant.locationInHome}

                                                    </c:when>


                                                    <c:otherwise>

                                                        Chưa cập nhật

                                                    </c:otherwise>


                                                </c:choose>


                                            </div>


                                        </div>



                                        <div class="detail-row">


                                            <div class="detail-label">

                                                Ngày trồng

                                            </div>


                                            <div class="detail-value">


                                                <c:choose>


                                                    <c:when test="${plant.plantedDate != null}">


                                                        <fmt:formatDate
                                                            value="${plant.plantedDate}"
                                                            pattern="dd/MM/yyyy" />


                                                    </c:when>


                                                    <c:otherwise>

                                                        Chưa cập nhật

                                                    </c:otherwise>


                                                </c:choose>


                                            </div>


                                        </div>



                                        <div class="detail-row">


                                            <div class="detail-label">

                                                Tình trạng

                                            </div>


                                            <div class="detail-value">

                                                ${plant.healthStatus}

                                            </div>


                                        </div>



                                        <div class="detail-row">


                                            <div class="detail-label">

                                                Ghi chú

                                            </div>


                                            <div class="detail-value">


                                                <c:choose>


                                                    <c:when test="${not empty plant.note}">

                                                        ${plant.note}

                                                    </c:when>


                                                    <c:otherwise>

                                                        Không có ghi chú

                                                    </c:otherwise>


                                                </c:choose>


                                            </div>


                                        </div>



                                        <%-- WATER INFO --%>

                                        <div class="detail-section-title
                                                    text-primary
                                                    mt-4">

                                            <i class="fa-solid fa-calendar-days me-1"></i>

                                            Lịch tưới

                                        </div>



                                        <c:choose>


                                            <c:when test="${schedule != null}">



                                                <div class="detail-row">


                                                    <div class="detail-label">

                                                        Tần suất

                                                    </div>


                                                    <div class="detail-value">

                                                        ${schedule.frequencyDays}
                                                        ngày/lần

                                                    </div>


                                                </div>



                                                <div class="detail-row">


                                                    <div class="detail-label">

                                                        Lần gần nhất

                                                    </div>


                                                    <div class="detail-value">


                                                        <c:choose>


                                                            <c:when test="${schedule.lastPerformed != null}">


                                                                <fmt:formatDate
                                                                    value="${schedule.lastPerformed}"
                                                                    pattern="dd/MM/yyyy" />


                                                            </c:when>


                                                            <c:otherwise>

                                                                Chưa thực hiện

                                                            </c:otherwise>


                                                        </c:choose>


                                                    </div>


                                                </div>



                                                <div class="detail-row">


                                                    <div class="detail-label">

                                                        Lần tiếp theo

                                                    </div>


                                                    <div class="detail-value">


                                                        <c:choose>


                                                            <c:when test="${schedule.nextDueDate != null}">


                                                                <fmt:formatDate
                                                                    value="${schedule.nextDueDate}"
                                                                    pattern="dd/MM/yyyy" />


                                                            </c:when>


                                                            <c:otherwise>

                                                                Chưa thiết lập

                                                            </c:otherwise>


                                                        </c:choose>


                                                    </div>


                                                </div>



                                                <div class="detail-row">


                                                    <div class="detail-label">

                                                        Trạng thái

                                                    </div>


                                                    <div class="detail-value">


                                                        <c:choose>


                                                            <c:when test="${waterStatus eq 'OVERDUE'}">

                                                                <span class="badge bg-danger">

                                                                    Quá hạn

                                                                </span>

                                                            </c:when>


                                                            <c:when test="${waterStatus eq 'TODAY'}">

                                                                <span class="badge bg-success">

                                                                    Cần tưới hôm nay

                                                                </span>

                                                            </c:when>


                                                            <c:when test="${waterStatus eq 'UPCOMING'}">

                                                                <span class="badge bg-light text-dark">

                                                                    Còn ${daysUntilWater} ngày

                                                                </span>

                                                            </c:when>


                                                            <c:otherwise>

                                                                <span class="text-muted">

                                                                    Chưa xác định

                                                                </span>

                                                            </c:otherwise>


                                                        </c:choose>


                                                    </div>


                                                </div>


                                            </c:when>



                                            <c:otherwise>


                                                <div class="text-muted small">

                                                    Cây này chưa có lịch tưới.

                                                </div>


                                            </c:otherwise>


                                        </c:choose>


                                    </div>


                                </div>


                            </div>



                            <%-- FOOTER --%>

                            <div class="modal-footer">


                                <a
                                    href="${pageContext.request.contextPath}/Diary?plantId=${plant.plantId}"
                                    class="btn btn-outline-warning">

                                    <i class="fa-solid fa-chart-line me-1"></i>

                                    Nhật ký phát triển

                                </a>


                                <button
                                    type="button"
                                    class="btn btn-secondary"
                                    data-bs-dismiss="modal">

                                    Đóng

                                </button>


                            </div>


                        </div>


                    </div>


                </div>


            </c:forEach>


        </div>


    </c:if>


</div>



<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>