<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>人员评分管理</title>
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
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			$(list+idx).find("select").each(function(){
				$(this).val($(this).attr("data-value"));
			});
			$(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
				var ss = $(this).attr("data-value").split(',');
				for (var i=0; i<ss.length; i++){
					if($(this).val() == ss[i]){
						$(this).attr("checked","checked");
					}
				}
			});
		}
		function delRow(obj, prefix){
			var id = $(prefix+"_id");
			var delFlag = $(prefix+"_delFlag");
			if (id.val() == ""){
				$(obj).parent().parent().remove();
			}else if(delFlag.val() == "0"){
				delFlag.val("1");
				$(obj).html("&divide;").attr("title", "撤销删除");
				$(obj).parent().parent().addClass("error");
			}else if(delFlag.val() == "1"){
				delFlag.val("0");
				$(obj).html("&times;").attr("title", "删除");
				$(obj).parent().parent().removeClass("error");
			}
		}
	</script>
</head>
<body>
	<ul class="nav nav-tabs my-nav-tabs">
		<li><a href="${ctx}/estimate/userEstimate/">人员评分列表</a></li>
		<li class="active"><a href="${ctx}/estimate/userEstimate/form?id=${userEstimate.id}">人员评分<shiro:hasPermission name="estimate:userEstimate:edit">${not empty userEstimate.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="estimate:userEstimate:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="userEstimate" action="${ctx}/estimate/userEstimate/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">归属部门：</label>
                <div class="controls">
                    <sys:treeselect id="office" name="office.id" value="${userEstimate.office.id}" labelName="office.name" labelValue="${userEstimate.office.name}"
                        title="部门" url="/sys/office/treeData?type=2" cssClass="required" allowClear="true" notAllowSelectParent="true"/>
                    <span class="help-inline"><font color="red">*</font> </span>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">登录名：</label>
                <div class="controls">
                    <form:input path="loginName" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
                    <span class="help-inline"><font color="red">*</font> </span>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">工号：</label>
                <div class="controls">
                    <form:input path="no" htmlEscape="false" maxlength="100" class="input-xlarge "/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">姓名：</label>
                <div class="controls">
                    <form:input path="name" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
                    <span class="help-inline"><font color="red">*</font> </span>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">邮箱：</label>
                <div class="controls">
                    <form:input path="email" htmlEscape="false" maxlength="200" class="input-xlarge "/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">手机：</label>
                <div class="controls">
                    <form:input path="mobile" htmlEscape="false" maxlength="200" class="input-xlarge "/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">用户类型：</label>
                <div class="controls">
                    <form:select path="userType" class="input-xlarge ">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('sys_user_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">评分合计：</label>
                <div class="controls">
                    <form:input path="fraction" htmlEscape="false" class="input-xlarge "/>
                </div>
            </div>
                <div class="control-group">
                    <label class="control-label">评分明细：</label>
                    <div class="controls">
                        <table id="contentTable" class="table table-striped table-bordered table-condensed">
                            <thead>
                                <tr>
                                    <th class="hide"></th>
                                    <th>归属部门</th>
                                    <th>登录名</th>
                                    <th>工号</th>
                                    <th>姓名</th>
                                    <th>邮箱</th>
                                    <th>手机</th>
                                    <th>用户类型</th>
                                    <th>项目主键</th>
                                    <th>分数</th>
                                    <th>进展情况</th>
                                    <th>备注信息</th>
                                    <th>项目编号</th>
                                    <th>level</th>
                                    <th>督办事项</th>
                                    <th>来源</th>
                                    <th>工作计划</th>
                                    <th>办结时限</th>
                                    <th>备注</th>
                                    <th>结束日期</th>
                                    <th>状态</th>
                                    <shiro:hasPermission name="estimate:userEstimate:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
                                </tr>
                            </thead>
                            <tbody id="userEstimateDetailList">
                            </tbody>
                            <shiro:hasPermission name="estimate:userEstimate:edit"><tfoot>
                                <tr><td colspan="22"><a href="javascript:" onclick="addRow('#userEstimateDetailList', userEstimateDetailRowIdx, userEstimateDetailTpl);userEstimateDetailRowIdx = userEstimateDetailRowIdx + 1;" class="btn">新增</a></td></tr>
                            </tfoot></shiro:hasPermission>
                        </table>
                        <script type="text/template" id="userEstimateDetailTpl">//<!--
                            <tr id="userEstimateDetailList{{idx}}">
                                <td class="hide">
                                    <input id="userEstimateDetailList{{idx}}_id" name="userEstimateDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
                                    <input id="userEstimateDetailList{{idx}}_delFlag" name="userEstimateDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
                                </td>
                                <td>
                                    <sys:treeselect id="userEstimateDetailList{{idx}}_office" name="userEstimateDetailList[{{idx}}].office.id" value="{{row.office.id}}" labelName="userEstimateDetailList{{idx}}.office.name" labelValue="{{row.office.name}}"
                                        title="部门" url="/sys/office/treeData?type=2" cssClass="required" allowClear="true" notAllowSelectParent="true"/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_loginName" name="userEstimateDetailList[{{idx}}].loginName" type="text" value="{{row.loginName}}" maxlength="100" class="input-small required"/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_no" name="userEstimateDetailList[{{idx}}].no" type="text" value="{{row.no}}" maxlength="100" class="input-small "/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_name" name="userEstimateDetailList[{{idx}}].name" type="text" value="{{row.name}}" maxlength="100" class="input-small required"/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_email" name="userEstimateDetailList[{{idx}}].email" type="text" value="{{row.email}}" maxlength="200" class="input-small "/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_mobile" name="userEstimateDetailList[{{idx}}].mobile" type="text" value="{{row.mobile}}" maxlength="200" class="input-small "/>
                                </td>
                                <td>
                                    <select id="userEstimateDetailList{{idx}}_userType" name="userEstimateDetailList[{{idx}}].userType" data-value="{{row.userType}}" class="input-small ">
                                        <option value=""></option>
                                        <c:forEach items="${fns:getDictList('sys_user_type')}" var="dict">
                                            <option value="${dict.value}">${dict.label}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_projectId" name="userEstimateDetailList[{{idx}}].projectId" type="text" value="{{row.projectId}}" maxlength="64" class="input-small "/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_fraction" name="userEstimateDetailList[{{idx}}].fraction" type="text" value="{{row.fraction}}" maxlength="11" class="input-small "/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_evolve" name="userEstimateDetailList[{{idx}}].evolve" type="text" value="{{row.evolve}}" maxlength="255" class="input-small "/>
                                </td>
                                <td>
                                    <textarea id="userEstimateDetailList{{idx}}_remarks" name="userEstimateDetailList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small ">{{row.remarks}}</textarea>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_num" name="userEstimateDetailList[{{idx}}].num" type="text" value="{{row.num}}" maxlength="20" class="input-small "/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_level" name="userEstimateDetailList[{{idx}}].level" type="text" value="{{row.level}}" maxlength="500" class="input-small "/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_items" name="userEstimateDetailList[{{idx}}].items" type="text" value="{{row.items}}" maxlength="500" class="input-small "/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_source" name="userEstimateDetailList[{{idx}}].source" type="text" value="{{row.source}}" maxlength="100" class="input-small "/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_jobPlain" name="userEstimateDetailList[{{idx}}].jobPlain" type="text" value="{{row.jobPlain}}" maxlength="500" class="input-small "/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_willFinishTime" name="userEstimateDetailList[{{idx}}].willFinishTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
                                        value="{{row.willFinishTime}}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_comments" name="userEstimateDetailList[{{idx}}].comments" type="text" value="{{row.comments}}" maxlength="500" class="input-small "/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_endTime" name="userEstimateDetailList[{{idx}}].endTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
                                        value="{{row.endTime}}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
                                </td>
                                <td>
                                    <input id="userEstimateDetailList{{idx}}_status" name="userEstimateDetailList[{{idx}}].status" type="text" value="{{row.status}}" maxlength="1" class="input-small "/>
                                </td>
                                <shiro:hasPermission name="estimate:userEstimate:edit"><td class="text-center" width="10">
                                    {{#delBtn}}<span class="close" onclick="delRow(this, '#userEstimateDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
                                </td></shiro:hasPermission>
                            </tr>//-->
                        </script>
                        <script type="text/javascript">
                            var userEstimateDetailRowIdx = 0, userEstimateDetailTpl = $("#userEstimateDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
                            $(document).ready(function() {
                                var data = ${fns:toJson(userEstimate.userEstimateDetailList)};
                                for (var i=0; i<data.length; i++){
                                    addRow('#userEstimateDetailList', userEstimateDetailRowIdx, userEstimateDetailTpl, data[i]);
                                    userEstimateDetailRowIdx = userEstimateDetailRowIdx + 1;
                                }
                            });
                        </script>
                    </div>
                </div>
            <div class="form-actions my-form-actions">
                <shiro:hasPermission name="estimate:userEstimate:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
                <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
            </div>
        </form:form>
    </div>
</body>
</html>