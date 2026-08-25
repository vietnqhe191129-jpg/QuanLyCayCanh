<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="vi">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width,
                   initial-scale=1.0">

    <title>Sửa Nhật Ký Phát Triển</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
        rel="stylesheet">

</head>


<body class="bg-light">

<div class="container py-5">

    <div class="row justify-content-center">

        <div class="col-md-8">

            <div class="card shadow-sm">

                <div class="card-header bg-warning">

                    <h5 class="mb-0">

                        <i class="fa-solid fa-pen me-2"></i>

                        Sửa Nhật Ký Phát Triển

                    </h5>

                </div>


                <div class="card-body">


                    <form
                        action="${pageContext.request.contextPath}/Diary"
                        method="POST">


                        <input type="hidden"
                               name="action"
                               value="update">


                        <input type="hidden"
                               name="diaryId"
                               value="${editDiary.diaryId}">


                        <input type="hidden"
                               name="plantId"
                               value="${editDiary.plantId}">


                        <div class="mb-3">

                            <label class="form-label">
                                Chiều cao (cm)
                            </label>

                            <input
                                type="number"
                                step="0.1"
                                min="0"
                                name="heightCm"
                                class="form-control"
                                value="${editDiary.heightCm}">

                        </div>


                        <div class="mb-3">

                            <label class="form-label">
                                URL ảnh
                            </label>

                            <input
                                type="text"
                                name="imageUrl"
                                class="form-control"
                                value="${editDiary.imageUrl}">

                        </div>


                        <div class="mb-3">

                            <label class="form-label">
                                Ghi chú
                            </label>

                            <textarea
                                name="note"
                                class="form-control"
                                rows="4">${editDiary.note}</textarea>

                        </div>


                        <div class="d-flex gap-2">


                            <button
                                type="submit"
                                class="btn btn-warning">

                                <i class="fa-solid fa-floppy-disk me-1"></i>

                                Lưu thay đổi

                            </button>


                            <a
                                href="${pageContext.request.contextPath}/Diary?plantId=${editDiary.plantId}"
                                class="btn btn-secondary">

                                Hủy

                            </a>


                        </div>


                    </form>

                </div>

            </div>

        </div>

    </div>

</div>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>