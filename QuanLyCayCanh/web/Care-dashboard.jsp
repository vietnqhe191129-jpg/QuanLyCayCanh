<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:useBean id="now" class="java.util.Date" />

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Quản Lý Chăm Sóc Cây Cảnh</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
        rel="stylesheet">

    <style>
        .plant-card {
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
            border-radius: 12px;
            overflow: hidden;
        }

        .plant-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }

        .plant-img {
            height: 200px;
            object-fit: cover;
            width: 100%;
        }

        .badge-healthy {
            background-color: #198754;
        }

        .badge-warning-custom {
            background-color: #ffc107;
            color: black;
        }

        .badge-sick {
            background-color: #dc3545;
        }

        .empty-box {
            min-height: 300px;
            display: flex;
            justify-content: center;
            align-items: center;
        }
    </style>

</head>

<body class="bg-light">

<div class="container py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h2 class="text-success m-0">
            <i class="fa-solid fa-seedling me-2"></i>
            Quản Lý Cây Cảnh
        </h2>

        <a href="${pageContext.request.contextPath}/add-plant"
           class="btn btn-success">

            <i class="fa-solid fa-plus me-1"></i>
            Thêm cây mới

        </a>

    </div>


    <%-- Không có cây --%>

    <c:if test="${empty plants}">

        <div class="card shadow-sm">

            <div class="card-body empty-box text-center">

                <div>

                    <i class="fa-solid fa-seedling fa-4x text-secondary mb-3"></i>

                    <h4>Bạn chưa có cây nào</h4>

                    <p class="text-muted">
                        Hãy thêm cây đầu tiên vào khu vườn của bạn.
                    </p>

                    <a href="${pageContext.request.contextPath}/add-plant"
                       class="btn btn-success">

                        <i class="fa-solid fa-plus me-1"></i>
                        Thêm cây

                    </a>

                </div>

            </div>

        </div>

    </c:if>


    <%-- Danh sách cây --%>

    <c:if test="${not empty plants}">

        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">

            <c:forEach var="plant" items="${plants}">

                <%-- Lấy lịch tưới WATER của cây --%>

                <c:set var="schedule"
                       value="${scheduleMap[plant.plantId]}" />


                <div class="col">

                    <div class="card h-100 plant-card shadow-sm"
                         data-bs-toggle="modal"
                         data-bs-target="#plantModal${plant.plantId}">


                        <%-- Ảnh cây --%>

                        <c:choose>

                            <c:when test="${not empty plant.imageUrl}">

                                <img
                                    src="${plant.imageUrl}"
                                    class="card-img-top plant-img"
                                    alt="${plant.customName}">

                            </c:when>

                            <c:otherwise>

                                <img
                                    src="https://via.placeholder.com/300x200?text=Plant+Image"
                                    class="card-img-top plant-img"
                                    alt="Plant Image">

                            </c:otherwise>

                        </c:choose>


                        <div class="card-body d-flex flex-column">

                            <h5 class="card-title fw-bold text-dark">
                                ${plant.customName}
                            </h5>


                            <p class="card-text text-muted small mb-2">

                                <i class="fa-solid fa-location-dot me-1"></i>

                                <c:choose>

                                    <c:when test="${not empty plant.locationInHome}">
                                        ${plant.locationInHome}
                                    </c:when>

                                    <c:otherwise>
                                        Chưa thiết lập vị trí
                                    </c:otherwise>

                                </c:choose>

                            </p>


                            <%-- Health Status --%>

                            <div class="mb-3">

                                <c:choose>

                                    <c:when test="${plant.healthStatus == 'Khỏe mạnh'}">

                                        <span class="badge badge-healthy px-2 py-1">

                                            <i class="fa-solid fa-heart me-1"></i>

                                            Khỏe mạnh

                                        </span>

                                    </c:when>

                                    <c:when test="${plant.healthStatus == 'Cần chăm sóc'}">

                                        <span class="badge badge-warning-custom px-2 py-1">

                                            <i class="fa-solid fa-triangle-exclamation me-1"></i>

                                            Cần chăm sóc

                                        </span>

                                    </c:when>

                                    <c:otherwise>

                                        <span class="badge badge-sick px-2 py-1">

                                            <i class="fa-solid fa-circle-exclamation me-1"></i>

                                            ${plant.healthStatus}

                                        </span>

                                    </c:otherwise>

                                </c:choose>

                            </div>


                            <%-- Lịch chăm sóc --%>

                            <div class="mt-auto pt-2 border-top">

                                <c:choose>

                                    <c:when test="${schedule == null}">

                                        <div class="text-center">

                                            <span class="text-secondary small">

                                                <i class="fa-solid fa-calendar-xmark me-1"></i>

                                                Chưa có lịch tưới

                                            </span>

                                        </div>

                                    </c:when>


                                    <c:when test="${schedule.nextDueDate != null
                                                    && schedule.nextDueDate.time <= now.time}">

                                        <form
                                            action="${pageContext.request.contextPath}/Water"
                                            method="POST"
                                            onclick="event.stopPropagation();">

                                            <input
                                                type="hidden"
                                                name="plantId"
                                                value="${plant.plantId}">

                                            <input
                                                type="hidden"
                                                name="scheduleId"
                                                value="${schedule.scheduleId}">

                                            <button
                                                type="submit"
                                                class="btn btn-primary btn-sm w-100 fw-bold">

                                                <i class="fa-solid fa-droplet me-1"></i>

                                                Tưới nước ngay

                                            </button>

                                        </form>

                                    </c:when>


                                    <c:otherwise>

                                        <div class="text-secondary small fw-semibold text-center">

                                            <i class="fa-solid fa-clock me-1"></i>

                                            Tưới tiếp vào:

                                            <span class="badge bg-info text-dark">

                                                <fmt:formatDate
                                                    value="${schedule.nextDueDate}"
                                                    pattern="dd/MM/yyyy" />

                                            </span>

                                        </div>

                                    </c:otherwise>

                                </c:choose>

                            </div>

                        </div>

                    </div>

                </div>


                <%-- Modal chi tiết từng cây --%>

                <div class="modal fade"
                     id="plantModal${plant.plantId}"
                     tabindex="-1"
                     aria-hidden="true">


                    <div class="modal-dialog modal-lg modal-dialog-centered">

                        <div class="modal-content">


                            <div class="modal-header bg-success text-white">

                                <h5 class="modal-title">

                                    <i class="fa-solid fa-circle-info me-2"></i>

                                    Chi Tiết Cây

                                </h5>

                                <button
                                    type="button"
                                    class="btn-close btn-close-white"
                                    data-bs-dismiss="modal"
                                    aria-label="Close">
                                </button>

                            </div>


                            <div class="modal-body">

                                <div class="row">


                                    <div class="col-md-5 text-center mb-3">

                                        <c:choose>

                                            <c:when test="${not empty plant.imageUrl}">

                                                <img
                                                    src="${plant.imageUrl}"
                                                    class="img-fluid rounded shadow-sm mb-3"
                                                    alt="${plant.customName}">

                                            </c:when>

                                            <c:otherwise>

                                                <img
                                                    src="https://via.placeholder.com/300x200?text=Plant+Detail"
                                                    class="img-fluid rounded shadow-sm mb-3"
                                                    alt="Plant Image">

                                            </c:otherwise>

                                        </c:choose>


                                        <h4 class="fw-bold">
                                            ${plant.customName}
                                        </h4>

                                    </div>


                                    <div class="col-md-7">


                                        <h6 class="fw-bold text-success border-bottom pb-2">

                                            <i class="fa-solid fa-leaf me-1"></i>

                                            Thông Tin Chung

                                        </h6>


                                        <ul class="list-unstyled small mb-4">

                                            <li class="mb-2">

                                                <strong>Vị trí:</strong>

                                                <c:choose>

                                                    <c:when test="${not empty plant.locationInHome}">
                                                        ${plant.locationInHome}
                                                    </c:when>

                                                    <c:otherwise>
                                                        Chưa cập nhật
                                                    </c:otherwise>

                                                </c:choose>

                                            </li>


                                            <li class="mb-2">

                                                <strong>Ngày trồng:</strong>

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

                                            </li>


                                            <li class="mb-2">

                                                <strong>Trạng thái:</strong>

                                                ${plant.healthStatus}

                                            </li>


                                            <li class="mb-2">

                                                <strong>Ghi chú:</strong>

                                                <c:choose>

                                                    <c:when test="${not empty plant.note}">
                                                        ${plant.note}
                                                    </c:when>

                                                    <c:otherwise>
                                                        Không có ghi chú
                                                    </c:otherwise>

                                                </c:choose>

                                            </li>

                                        </ul>


                                        <h6 class="fw-bold text-primary border-bottom pb-2">

                                            <i class="fa-solid fa-calendar-days me-1"></i>

                                            Lịch Chăm Sóc

                                        </h6>


                                        <c:choose>

                                            <c:when test="${schedule != null}">

                                                <ul class="list-unstyled small mb-4">

                                                    <li class="mb-2">

                                                        <strong>Hoạt động:</strong>

                                                        <c:choose>

                                                            <c:when test="${schedule.actionType == 'WATER'}">
                                                                Tưới nước
                                                            </c:when>

                                                            <c:when test="${schedule.actionType == 'FERTILIZE'}">
                                                                Bón phân
                                                            </c:when>

                                                            <c:when test="${schedule.actionType == 'PRUNE'}">
                                                                Cắt tỉa
                                                            </c:when>

                                                            <c:when test="${schedule.actionType == 'REPOT'}">
                                                                Thay đất / thay chậu
                                                            </c:when>

                                                            <c:otherwise>
                                                                ${schedule.actionType}
                                                            </c:otherwise>

                                                        </c:choose>

                                                    </li>


                                                    <li class="mb-2">

                                                        <strong>Tần suất:</strong>

                                                        ${schedule.frequencyDays} ngày/lần

                                                    </li>


                                                    <li class="mb-2">

                                                        <strong>Lần gần nhất:</strong>

                                                        <c:choose>

                                                            <c:when test="${schedule.lastPerformed != null}">

                                                                <fmt:formatDate
                                                                    value="${schedule.lastPerformed}"
                                                                    pattern="dd/MM/yyyy HH:mm" />

                                                            </c:when>

                                                            <c:otherwise>
                                                                Chưa thực hiện
                                                            </c:otherwise>

                                                        </c:choose>

                                                    </li>


                                                    <li>

                                                        <strong>Lần tiếp theo:</strong>

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

                                                    </li>

                                                </ul>

                                            </c:when>


                                            <c:otherwise>

                                                <p class="text-muted small">
                                                    Cây này chưa có lịch tưới nước.
                                                </p>

                                            </c:otherwise>

                                        </c:choose>


                                        <h6 class="fw-bold text-warning border-bottom pb-2">

                                            <i class="fa-solid fa-chart-line me-1"></i>

                                            Nhật Ký Phát Triển

                                        </h6>


                                        <p class="text-muted small">
                                            Nhật ký phát triển sẽ được kết nối với
                                            bảng GrowthDiaries ở bước tiếp theo.
                                        </p>

                                    </div>

                                </div>

                            </div>


                            <div class="modal-footer">

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