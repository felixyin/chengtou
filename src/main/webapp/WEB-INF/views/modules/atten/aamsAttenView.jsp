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
	<ul class="nav nav-tabs  my-nav-tabs ">
		<li><a href="${ctx}/atten/aamsAtten/">考勤列表</a></li>
		<li class="active"><a href="${ctx}/atten/aamsAtten/form?id=${aamsAtten.id}">考勤<shiro:hasPermission name="atten:aamsAtten:edit">${not empty aamsAtten.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="atten:aamsAtten:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="aamsAtten" action="${ctx}/atten/aamsAtten/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day1}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day2}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day3}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day4}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day5}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day6}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day7}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day8}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day9}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day10}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day11}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day12}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day13}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day14}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day15}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day16}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day17}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day18}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day19}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day20}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day21}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day22}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day23}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day24}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day25}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day26}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day27}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day28}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day29}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day30}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">分数：</label>
                <div class="controls">
                    ${aamsAtten.day31}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">工作天数：</label>
                <div class="controls">
                    ${aamsAtten.workDays}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">实际出勤天数：</label>
                <div class="controls">
                    ${aamsAtten.realDays}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">缺勤天数：</label>
                <div class="controls">
                    ${aamsAtten.queqinDays}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">扣分：</label>
                <div class="controls">
                    ${aamsAtten.score}
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