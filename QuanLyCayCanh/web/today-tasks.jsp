<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
           prefix="c" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>


<!DOCTYPE html>

<html lang="vi">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width,
              initial-scale=1.0">

        <title>Việc Chăm Sóc Hôm Nay</title>

        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet">

        <link
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
            rel="stylesheet">

        <style>

            .task-card {
                border-radius: 12px;
            }

            .task-icon {
                width: 45px;
                height: 45px;

                display: flex;
                justify-content: center;
                align-items: center;

                border-radius: 50%;

                font-size: 20px;

                background-color: #f1f3f5;
            }

            .overdue {
                border-left: 5px solid #dc3545;
            }

            .today {
                border-left: 5px solid #198754;
            }

        </style>

    </head>


    <body class="bg-light">


        <div class="container py-4">


            <div class="d-flex
                 justify-content-between
                 align-items-center
                 mb-4">


                <div>

                    <h2 class="text-success mb-1">

                        <i class="fa-solid
                           fa-list-check
                           me-2"></i>

                        Việc Chăm Sóc Hôm Nay

                    </h2>

                    <p class="text-muted mb-0">
                        Các công việc đến hạn hoặc đã quá hạn.
                    </p>

                </div>


                <a href="${pageContext.request.contextPath}/Care"
                   class="btn btn-outline-secondary">

                    <i class="fa-solid
                       fa-arrow-left
                       me-1"></i>

                    Quay lại

                </a>

            </div>


            <%-- Không có task --%>

            <c:if test="${empty tasks}">

                <div class="alert
                     alert-success
                     text-center">

                    <i class="fa-solid
                       fa-circle-check
                       me-2"></i>

                    Hôm nay không có công việc chăm sóc nào cần thực hiện.

                </div>

            </c:if>


            <%-- Có task --%>

            <c:if test="${not empty tasks}">


                <div class="row g-3">


                    <c:forEach var="task"
                               items="${tasks}">


                        <c:set var="plant"
                               value="${plantMap[task.plantId]}" />
                        <c:set var="isOverdue"
                               value="${overdueMap[task.scheduleId]}" />

                        <div class="col-12">


                            <div class="card
                                 shadow-sm
                                 task-card
                                 ${isOverdue ? 'overdue' : 'today'}">


                                <div class="card-body">


                                    <div class="row
                                         align-items-center">


                                        <%-- Icon --%>

                                        <div class="col-auto">


                                            <div class="task-icon">


                                                <c:choose>


                                                    <c:when test="${task.actionType == 'WATER'}">

                                                        <i class="fa-solid
                                                           fa-droplet
                                                           text-primary"></i>

                                                    </c:when>


                                                    <c:when test="${task.actionType == 'FERTILIZE'}">

                                                        <i class="fa-solid
                                                           fa-seedling
                                                           text-success"></i>

                                                    </c:when>


                                                    <c:when test="${task.actionType == 'PRUNE'}">

                                                        <i class="fa-solid
                                                           fa-scissors
                                                           text-warning"></i>

                                                    </c:when>


                                                    <c:when test="${task.actionType == 'REPOT'}">

                                                        <i class="fa-solid
                                                           fa-bucket
                                                           text-secondary"></i>

                                                    </c:when>


                                                    <c:otherwise>

                                                        <i class="fa-solid
                                                           fa-leaf"></i>

                                                    </c:otherwise>


                                                </c:choose>


                                            </div>


                                        </div>


                                        <%-- Nội dung --%>

                                        <div class="col">


                                            <h5 class="mb-1">

                                                <c:choose>

                                                    <c:when test="${plant != null}">
                                                        ${plant.customName}
                                                    </c:when>

                                                    <c:otherwise>
                                                        Plant #${task.plantId}
                                                    </c:otherwise>

                                                </c:choose>

                                            </h5>


                                            <div class="text-muted small">


                                                <c:choose>


                                                    <c:when test="${task.actionType == 'WATER'}">

                                                        Tưới nước

                                                    </c:when>


                                                    <c:when test="${task.actionType == 'FERTILIZE'}">

                                                        Bón phân

                                                    </c:when>


                                                    <c:when test="${task.actionType == 'PRUNE'}">

                                                        Cắt tỉa

                                                    </c:when>


                                                    <c:when test="${task.actionType == 'REPOT'}">

                                                        Thay đất / thay chậu

                                                    </c:when>


                                                    <c:otherwise>

                                                        ${task.actionType}

                                                    </c:otherwise>


                                                </c:choose>


                                                ·

                                                ${task.frequencyDays}
                                                ngày/lần

                                            </div>


                                            <div class="small mt-2">


                                                <span class="fw-semibold">
                                                    Hạn:
                                                </span>


                                                <fmt:formatDate
                                                    value="${task.nextDueDate}"
                                                    pattern="dd/MM/yyyy" />


                                            </div>


                                            <c:choose>

                                                <c:when test="${isOverdue}">

                                                    <span class="badge bg-danger mt-2">

                                                        <i class="fa-solid
                                                           fa-triangle-exclamation
                                                           me-1"></i>

                                                        Quá hạn

                                                    </span>

                                                </c:when>

                                                <c:otherwise>

                                                    <span class="badge bg-success mt-2">

                                                        <i class="fa-solid
                                                           fa-calendar-check
                                                           me-1"></i>

                                                        Hôm nay

                                                    </span>

                                                </c:otherwise>

                                            </c:choose>


                                        </div>


                                        <%-- Nút hoàn thành --%>

                                        <div class="col-md-auto mt-3 mt-md-0">


                                            <form
                                                action="${pageContext.request.contextPath}/CareLog"
                                                method="POST">


                                                <input
                                                    type="hidden"
                                                    name="scheduleId"
                                                    value="${task.scheduleId}">


                                                <input
                                                    type="hidden"
                                                    name="plantId"
                                                    value="${task.plantId}">


                                                <input
                                                    type="hidden"
                                                    name="actionType"
                                                    value="${task.actionType}">


                                                <button
                                                    type="submit"
                                                    class="btn btn-success">

                                                    <i class="fa-solid
                                                       fa-check
                                                       me-1"></i>

                                                    Hoàn thành

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


        <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
        </script>


    </body>

</html>