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

        <style>
            .diary-card {
                border-radius: 12px;
                overflow: hidden;
            }

            .diary-image {
                width: 100%;
                height: 220px;
                object-fit: cover;
            }

            .timeline-date {
                font-size: 0.9rem;
            }
        </style>
    </head>

    <body class="bg-light">

        <div class="container py-4">

            <div class="d-flex justify-content-between
                 align-items-center
                 mb-4">

                <div>

                    <h2 class="text-success mb-1">

                        <i class="fa-solid fa-chart-line me-2"></i>

                        Nhật Ký Phát Triển

                    </h2>

                    <span class="text-muted">
                        Plant ID: ${plantId}
                    </span>

                </div>

                <a href="${pageContext.request.contextPath}/Care"
                   class="btn btn-outline-secondary">

                    <i class="fa-solid fa-arrow-left me-1"></i>

                    Quay lại

                </a>

            </div>


            <%-- Form thêm nhật ký --%>

            <div class="card shadow-sm mb-4">

                <div class="card-header bg-success text-white">

                    <strong>
                        <i class="fa-solid fa-plus me-1"></i>
                        Thêm nhật ký mới
                    </strong>

                </div>

                <div class="card-body">

                    <form action="${pageContext.request.contextPath}/Diary"
                          method="POST">

                        <input type="hidden"
                               name="plantId"
                               value="${plantId}">


                        <div class="row">

                            <div class="col-md-4 mb-3">

                                <label class="form-label">
                                    Chiều cao (cm)
                                </label>

                                <input type="number"
                                       step="0.1"
                                       min="0"
                                       name="heightCm"
                                       class="form-control"
                                       placeholder="VD: 35.5">

                            </div>


                            <div class="col-md-8 mb-3">

                                <label class="form-label">
                                    URL ảnh
                                </label>

                                <input type="text"
                                       name="imageUrl"
                                       class="form-control"
                                       placeholder="VD: images/plant-growth-1.jpg">

                            </div>

                        </div>


                        <div class="mb-3">

                            <label class="form-label">
                                Ghi chú
                            </label>

                            <textarea name="note"
                                      class="form-control"
                                      rows="3"
                                      placeholder="VD: Cây mọc thêm chồi mới..."></textarea>

                        </div>


                        <button type="submit"
                                class="btn btn-success">

                            <i class="fa-solid fa-floppy-disk me-1"></i>

                            Lưu nhật ký

                        </button>

                    </form>

                </div>

            </div>


            <%-- Không có nhật ký --%>

            <c:if test="${empty diaries}">

                <div class="alert alert-secondary text-center">

                    <i class="fa-solid fa-seedling me-1"></i>

                    Cây này chưa có nhật ký phát triển.

                </div>

            </c:if>


            <%-- Danh sách diary --%>

            <c:if test="${not empty diaries}">

                <div class="row g-4">

                    <c:forEach var="diary"
                               items="${diaries}">

                        <div class="col-md-6 col-lg-4">

                            <div class="card diary-card h-100 shadow-sm">


                                <c:choose>

                                    <c:when test="${not empty diary.imageUrl}">

                                        <img src="${diary.imageUrl}"
                                             class="diary-image"
                                             alt="Growth Image">

                                    </c:when>

                                    <c:otherwise>

                                        <img src="https://via.placeholder.com/400x220?text=Growth+Diary"
                                             class="diary-image"
                                             alt="Growth Image">

                                    </c:otherwise>

                                </c:choose>


                                <div class="card-body">

                                    <div class="timeline-date
                                         text-muted
                                         mb-2">

                                        <i class="fa-solid fa-calendar-days me-1"></i>

                                        <fmt:formatDate
                                            value="${diary.logDate}"
                                            pattern="dd/MM/yyyy HH:mm" />

                                    </div>


                                    <c:if test="${diary.heightCm != null}">

                                        <p class="mb-2">

                                            <strong>
                                                <i class="fa-solid fa-ruler-vertical me-1"></i>
                                                Chiều cao:
                                            </strong>

                                            ${diary.heightCm} cm

                                        </p>

                                    </c:if>


                                    <p class="mb-0">

                                        <strong>Ghi chú:</strong>

                                        <c:choose>

                                            <c:when test="${not empty diary.note}">
                                                ${diary.note}
                                            </c:when>

                                            <c:otherwise>
                                                Không có ghi chú.
                                            </c:otherwise>

                                        </c:choose>

                                    </p>
                                    <div class="mt-3 d-flex gap-2">

                                        <a href="${pageContext.request.contextPath}/Diary?action=edit&diaryId=${diary.diaryId}"
                                           class="btn btn-warning btn-sm">

                                            <i class="fa-solid fa-pen me-1"></i>
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
                                                    class="btn btn-danger btn-sm">

                                                <i class="fa-solid fa-trash me-1"></i>
                                                Xóa

                                            </button>

                                        </form>

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