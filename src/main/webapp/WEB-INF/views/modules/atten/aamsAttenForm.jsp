<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>考勤管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
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
	<ul class="nav nav-tabs my-nav-tabs">
		<li><a href="${ctx}/atten/aamsAtten/">考勤列表</a></li>
		<li class="active"><a href="${ctx}/atten/aamsAtten/form?id=${aamsAtten.id}">考勤<shiro:hasPermission name="atten:aamsAtten:edit">${not empty aamsAtten.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="atten:aamsAtten:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="aamsAtten" action="${ctx}/atten/aamsAtten/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day1" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day2" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day3" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day4" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day5" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day6" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day7" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day8" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day9" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day10" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day11" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day12" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day13" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day14" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day15" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day16" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day17" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day18" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day19" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day20" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day21" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day22" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day23" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day24" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day25" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day26" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day27" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day28" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day29" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day30" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    <form:input path="day31" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">工作天数：</label>
                <div class="controls">
                    <form:input path="workDays" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">实际出勤天数：</label>
                <div class="controls">
                    <form:input path="realDays" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">缺勤天数：</label>
                <div class="controls">
                    <form:input path="queqinDays" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">扣分：</label>
                <div class="controls">
                    <form:input path="score" htmlEscape="false" maxlength="2" class="input-xlarge  digits"/>
                </div>
            </div>
            <div class="form-actions my-form-actions">
                <shiro:hasPermission name="atten:aamsAtten:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
                <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
            </div>
        </form:form>
    </div>
</body>
</html>