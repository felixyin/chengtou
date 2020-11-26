<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>评分明细</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#name").focus();
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
        });
    </script>
</head>
<body>
<div class="my-container">
    <div class="header">
        <div id="messageBox" class="alert alert-error ${empty message ? 'hide' : ''}">
            <button data-dismiss="alert" class="close">×</button>
            <label id="loginError" class="error">${message}</label>
        </div>
    </div>
    <form:form id="inputForm" modelAttribute="oaEstimateApprove"
               action="${ctx}/approve/estimate/oaEstimateApprove/approve"
               method="post" class="form-horizontal">
        <form:hidden path="id"/>
        <form:hidden path="act.taskId"/>
        <form:hidden path="act.taskName"/>
        <form:hidden path="act.taskDefKey"/>
        <form:hidden path="act.procInsId"/>
        <form:hidden path="act.procDefId"/>
        <form:hidden id="flag" path="act.flag"/>
        <sys:message content="${message}"/>
        <div class="control-group hide">
            <label class="control-label">流程实例编号：</label>
            <div class="controls">
                <form:input path="procInsId" htmlEscape="false" maxlength="64" class="input-xlarge "/>
            </div>
        </div>
        <div class="control-group hide">
            <label class="control-label">评分外建：</label>
            <div class="controls">
                <form:input path="estimate.id" htmlEscape="false" maxlength="64" class="input-xlarge "/>
            </div>
        </div>
        <div class="control-group hide">
            <label class="control-label">申请人外键：</label>
            <div class="controls">
                <form:input path="approveUser.id" htmlEscape="false" maxlength="64" class="input-xlarge "/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">原评分：</label>
            <div class="controls">
                <form:input path="estimate.fraction" htmlEscape="false" maxlength="11" class="input-xlarge "
                            readonly="true"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">进展情况：</label>
            <div class="controls">
                <form:textarea path="estimate.evolve" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "
                               readonly="true"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">申请评分：</label>
            <div class="controls">
                <form:input path="fractionApprove" type="number" htmlEscape="false" maxlength="11" class="input-xlarge required"
                            readonly="${fn:contains(roleStr, 'p')?'false':'true'}"/>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">申请原因：</label>
            <div class="controls">
                <form:textarea path="reason" htmlEscape="false" rows="4" maxlength="500" class="input-xxlarge required"
                               readonly="${fn:contains(roleStr, 'p')?'false':'true'}"/>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">单位负责人：</label>
            <div class="controls">
                <sys:treeselect id="bossUser" name="bossUser.id"
                                value="${oaEstimateApprove.bumenUser.id}"
                                labelName="user.name" labelValue="${oaEstimateApprove.bossUser.name}"
                                title="用户" url="/sys/office/treeData?type=3" cssClass="required" allowClear="true"
                                notAllowSelectParent="true"
                                disabled="${fn:contains(roleStr, 'p')?'':'disabled'}"/>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="form-actions my-form-actions">
            <shiro:hasPermission name="approve:estimate:oaEstimateApprove:edit">
                <input id="btnSubmit" class="btn btn-primary" type="submit" value="提交申请"/>&nbsp;
            </shiro:hasPermission>
            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>

        <c:if test="${not empty oaEstimateApprove.id}">
            <act:histoicFlow procInsId="${oaEstimateApprove.act.procInsId}"/>
        </c:if>
    </form:form>
</div>
</body>
</html>