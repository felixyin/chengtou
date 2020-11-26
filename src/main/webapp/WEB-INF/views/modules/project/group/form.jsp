<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>集团督办项目管理</title>
    <meta name="decorator" content="default"/>
    <style rel="stylesheet">
        /* textarea 自适应父容器大小 */
        .ttarea {
            width: 90%; /*自动适应父布局宽度*/
            overflow: auto;
            word-break: break-all;
            /*在ie中解决断行问题(防止自动变为在一行显示，主要解决ie兼容问题，ie8中当设宽度为100%时，文本域类容超过一行时，当我们双击文本内容就会自动变为一行显示，所以只能用ie的专有断行属性“word-break或word-wrap”控制其断行)*/
        }
        .my-parent-tr > td{
            background-color: lightblue!important;
        }
    </style>
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
        
        function addParentRow(list, idx, tpl, row) {
            window['aamsEstimateRowIdx' + aamsProjectUserRowIdx] = 0;
            addRow(list, idx, tpl, row)
        }

        function addSubRow(list, owner, idx, tpl, row) {
            var parentIdx = '';
            if (typeof(owner) == 'number') {
                parentIdx = owner;
            } else {
                parentIdx = $(owner).data('parent');
            }
            $(list).append(Mustache.render(tpl, {
                parentIdx: parentIdx, idx: idx, delBtn: true, row: row
            }));
            $(list + idx).find("select").each(function () {
                $(this).val($(this).attr("data-value"));
            });
            $(list + idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                var ss = $(this).attr("data-value").split(',');
                for (var i = 0; i < ss.length; i++) {
                    if ($(this).val() == ss[i]) {
                        $(this).attr("checked", "checked");
                    }
                }
            });
        }
        
        function addRow(list, idx, tpl, row) {
            $(list).append(Mustache.render(tpl, {
                idx: idx, delBtn: true, row: row
            }));
            $(list + idx).find("select").each(function () {
                $(this).val($(this).attr("data-value"));
            });
            $(list + idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                var ss = $(this).attr("data-value").split(',');
                for (var i = 0; i < ss.length; i++) {
                    if ($(this).val() == ss[i]) {
                        $(this).attr("checked", "checked");
                    }
                }
            });
        }

        function addSubTable(list, idx, tpl, row) {
            var html = Mustache.render(tpl, {
                idx: idx, delBtn: true, row: row
            });
            $(list).append(html);
        }

        function delRow(obj, prefix) {
            var id = $(prefix + "_id");
            var delFlag = $(prefix + "_delFlag");
            if (id.val() == "") {
                $(obj).parent().parent().remove();
            } else if (delFlag.val() == "0") {
                delFlag.val("1");
                $(obj).html("&divide;").attr("title", "撤销删除");
                $(obj).parent().parent().addClass("error");
            } else if (delFlag.val() == "1") {
                delFlag.val("0");
                $(obj).html("&times;").attr("title", "删除");
                $(obj).parent().parent().removeClass("error");
            }
        }
    </script>
</head>
<body>
<ul class="nav nav-tabs my-nav-tabs">
    <li><a href="${ctx}/project/group/">集团督办项目列表</a></li>
    <li class="active"><a href="${ctx}/project/group/form?id=${aamsProject.id}">集团督办项目<shiro:hasPermission
            name="project:group:edit">${not empty aamsProject.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission
            name="project:group:edit">查看</shiro:lacksPermission></a></li>
</ul>
<br/>
<div class="my-container">
    <form:form id="inputForm" modelAttribute="aamsProject" action="${ctx}/project/group/save" method="post"
               class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>

        <div class="control-group">
            <label class="control-label">督办类型：</label>
            <div class="controls">
                <shiro:hasPermission name="project:group:type">
                    <form:select path="type" class="input-xlarge ">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('project_type')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </shiro:hasPermission>
                <shiro:lacksPermission name="project:group:type">
                    ${fns:getDictLabel("type","project_type","个人督办" )}
                    <input type="hidden" name="type" value="3"/>
                </shiro:lacksPermission>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">紧急级别：</label>
            <div class="controls">
                <form:select path="level" class="input-xlarge ">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('project_level')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">督办事项：</label>
            <div class="controls">
                <div style="width: 90%;">
                    <form:textarea path="items" htmlEscape="false" rows="3" maxlength="500"
                                   class="input-xxlarge required hide"/>
                    <sys:ckeditor replace="items" uploadPath="/test" height="100"/>
                </div>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">来源：</label>
            <div class="controls">
                <form:textarea path="source" htmlEscape="false" rows="2" maxlength="100"
                               class="input-xxlarge required"/>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">责任部门：</label>
            <div class="controls">
                <sys:treeselect id="office" name="office.id" value="${aamsProject.office.id}" labelName="office.name"
                                labelValue="${aamsProject.office.name}"
                                title="部门" url="/sys/office/treeData?type=2" cssClass="required" allowClear="true"
                                notAllowSelectParent="false"/>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">工作计划：</label>
            <div class="controls">
                <div style="width: 90%;">
                    <form:textarea path="jobPlain" htmlEscape="false" rows="6" maxlength="500"
                                   class="input-xxlarge required"/>
                    <sys:ckeditor replace="jobPlain" uploadPath="/test" height="250"/>
                </div>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">办结时限：</label>
            <div class="controls">
                <input name="willFinishTime" type="text" readonly="readonly" maxlength="20"
                       class="input-medium Wdate required"
                       value="<fmt:formatDate value="${aamsProject.willFinishTime}" pattern="yyyy-MM-dd"/>"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">进展情况：</label>
            <div class="controls">
                <form:textarea path="evolve" htmlEscape="false" rows="4" maxlength="500"
                               class="input-xxlarge required"/>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">备注：</label>
            <div class="controls">
                <form:textarea path="comments" htmlEscape="false" rows="2" maxlength="500" class="input-xxlarge "/>
            </div>
        </div>
        <%--<div class="control-group">--%>
        <%--<label class="control-label">归档日期：</label>--%>
        <%--<div class="controls">--%>
        <%--<input name="endTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "--%>
        <%--value="<fmt:formatDate value="${aamsProject.endTime}" pattern="yyyy-MM-dd"/>"--%>
        <%--onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>--%>
        <%--</div>--%>
        <%--</div>--%>
        <div class="control-group">
            <label class="control-label">附件：</label>
            <div class="controls">
                <form:hidden id="files" path="files" htmlEscape="false" maxlength="500" class="input-xlarge"/>
                <sys:ckfinder input="files" type="files" uploadPath="/project/aamsProject" selectMultiple="true"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">状态：</label>
            <div class="controls">
                <shiro:hasPermission name="project:group:status">
                    <form:select id="status" path="status" class="input-xlarge ">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('project_types')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </shiro:hasPermission>
                <shiro:lacksPermission name="project:group:status">
                    <c:set var="status" scope="request" target="aamsProject" property="status" value="3"></c:set>
                    ${fns:getDictLabel("status","project_types","进行中" )}
                    <input type="hidden" name="status" value="3"/>
                </shiro:lacksPermission>
            </div>
        </div>


        <script type="text/template" id="aamsEstimateTpl">//<!--
            <tr id="aamsEstimateListDel{{parentIdx}}{{idx}}">
                <td class="hide">
                    <input id="aamsEstimateListDel{{parentIdx}}{{idx}}_id" name="aamsProjectUserList[{{parentIdx}}].aamsEstimateList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
                    <input id="aamsEstimateListDel{{parentIdx}}{{idx}}_delFlag" name="aamsProjectUserList[{{parentIdx}}].aamsEstimateList[{{idx}}].delFlag" type="hidden" value="0"/>
                </td>
                <td style="width:150px">
                    <input id="aamsEstimateListDel{{parentIdx}}{{idx}}_fraction" name="aamsProjectUserList[{{parentIdx}}].aamsEstimateList[{{idx}}].fraction" type="number" value="{{row.fraction}}" maxlength="10" class="input-small"/>
                </td>
                <td style="width:60%">
                    <textarea id="aamsEstimateListDel{{parentIdx}}{{idx}}_evolve" name="aamsProjectUserList[{{parentIdx}}].aamsEstimateList[{{idx}}].evolve" rows="2"  maxlength="255" class="ttarea">{{row.evolve}}</textarea>
                </td>
                <td>
                    <textarea id="aamsEstimateListDel{{parentIdx}}{{idx}}_remarks" name="aamsProjectUserList[{{parentIdx}}].aamsEstimateList[{{idx}}].remarks" rows="2"  maxlength="255" class="ttarea">{{row.remarks}}</textarea>
                </td>
                <shiro:hasPermission name="project:group:estimate"><td class="text-center" width="10">
                    {{#delBtn}}<span class="close" onclick="delRow(this, '#aamsEstimateListDel{{parentIdx}}{{idx}}')" title="删除">&times;</span>{{/delBtn}}
                </td></shiro:hasPermission>
            </tr>

            //-->
        </script>


        <div class="control-group">
            <label class="control-label">项目负责人：</label>
            <div class="controls">
                <table id="contentTable1" class="table table-striped table-bordered table-condensed"
                       style="width: 90%;">
                    <thead>
                    <tr>
                        <th class="hide"></th>
                        <th>项目负责人</th>
                        <th>备注信息</th>
                        <shiro:hasPermission name="project:group:user">
                            <th width="10">&nbsp;</th>
                        </shiro:hasPermission>
                    </tr>
                    </thead>
                    <tbody id="aamsProjectUserList">
                    </tbody>
                    <shiro:hasPermission name="project:group:user">
                        <tfoot>
                        <tr>
                            <td colspan="4"><a href="javascript:"
                                               onclick="addParentRow('#aamsProjectUserList', aamsProjectUserRowIdx, aamsProjectUserTpl);aamsProjectUserRowIdx = aamsProjectUserRowIdx + 1;"
                                               class="btn">新增</a></td>
                        </tr>
                        </tfoot>
                    </shiro:hasPermission>
                </table>
                <script type="text/template" id="aamsProjectUserTpl">//<!--
                            <tr id="aamsProjectUserList{{idx}}"  class="my-parent-tr">
                                <td class="hide">
                                    <input id="aamsProjectUserList{{idx}}_id" name="aamsProjectUserList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
                                    <input id="aamsProjectUserList{{idx}}_delFlag" name="aamsProjectUserList[{{idx}}].delFlag" type="hidden" value="0"/>
                                </td>
                                <td style="width:200px">
                                    <sys:treeselect id="aamsProjectUserList{{idx}}_user" name="aamsProjectUserList[{{idx}}].user.id" value="{{row.user.id}}" labelName="aamsProjectUserList{{idx}}.user.name" labelValue="{{row.user.name}}"
                                        title="用户" url="/sys/office/treeData?type=3" cssClass="required input-small" allowClear="true" notAllowSelectParent="true"/>
                                </td>
                                <td>
                                    <textarea id="aamsProjectUserList{{idx}}_remarks" name="aamsProjectUserList[{{idx}}].remarks" rows="2" maxlength="255" class="ttarea">{{row.remarks}}</textarea>
                                </td>
                                <shiro:hasPermission name="project:group:user"><td class="text-center" width="10">
                                    {{#delBtn}}<span class="close" onclick="delRow(this, '#aamsProjectUserList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
                                </td></shiro:hasPermission>
                            </tr>

                            <tr><td colspan="3">
                                <table id="contentTable{{idx}}" class="table table-striped table-bordered table-condensed" style="width: 90%;">
                                    <thead>
                                    <tr>
                                        <th class="hide"></th>
                                        <th>分数</th>
                                        <th>进展情况</th>
                                        <th>备注信息</th>
                                        <shiro:hasPermission name="project:group:estimate">
                                        <th width="10">&nbsp;</th>
                                        </shiro:hasPermission>
                                    </tr>
                                    </thead>
                                    <tbody id="aamsEstimateList{{idx}}">
                                    </tbody>
                            </td></tr>
                            <shiro:hasPermission name="project:group:estimate">
                                <tr>
                                <td colspan="5"><a href="javascript:" data-parent="{{idx}}"
                                onclick="addSubRow('#aamsEstimateList{{idx}}', this, aamsEstimateRowIdx{{idx}}, aamsEstimateTpl);aamsEstimateRowIdx{{idx}} = aamsEstimateRowIdx{{idx}} + 1;"
                                class="btn">新增评分</a></td>
                                </tr>
                            </shiro:hasPermission>
                            <tr style="border:3px;">
                                <td colspan="3"><hr/></td>
                            </tr>
                            //-->
                </script>
                <script type="text/javascript">
                    var aamsProjectUserRowIdx = 0,
                        aamsProjectUserTpl = $("#aamsProjectUserTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");

                    var aamsEstimateTpl = $("#aamsEstimateTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");

                    $(document).ready(function () {
                        var data = ${fns:toJson(aamsProject.aamsProjectUserList)};
                        for (var i = 0; i < data.length; i++) {
                            addParentRow('#aamsProjectUserList', aamsProjectUserRowIdx, aamsProjectUserTpl, data[i]);

                            var subData = data[i].aamsEstimateList;
                            if (subData) {
                                for (var subI = 0; subI < subData.length; subI++) {
                                    var d = subData[subI];
                                    addSubRow('#aamsEstimateList' + aamsProjectUserRowIdx, aamsProjectUserRowIdx, window['aamsEstimateRowIdx' + aamsProjectUserRowIdx], aamsEstimateTpl, d);
                                    window['aamsEstimateRowIdx' + aamsProjectUserRowIdx] = window['aamsEstimateRowIdx' + aamsProjectUserRowIdx] + 1;
                                }
                            }

                            aamsProjectUserRowIdx = aamsProjectUserRowIdx + 1;
                        }
                    });
                </script>
            </div>
        </div>



        <div class="form-actions my-form-actions">
            <script type="text/javascript">
                function setStatus(status) {
                    $('#status').val(status);
                    return true;
                }
            </script>

            <%--<c:if test="${aamsProject.status == 1 || aamsProject.status == 2 || aamsProject.status == 5}"> &lt;%&ndash; 3：进行中；4：结项，不能修改，其余情况可以修改 &ndash;%&gt;--%>
                <shiro:hasPermission name="project:group:save">
                    <input id="btnSubmit" class="btn btn-success" type="submit"
                           value="&nbsp;&nbsp;保&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;存&nbsp;&nbsp;"/>
                    &nbsp;&nbsp;&nbsp;
                </shiro:hasPermission>
            <%--</c:if>--%>

            <c:if test="${status == 3 || aamsProject.status == 1 || aamsProject.status == 5}"> <%--1:未提交状态--%>
                <shiro:hasPermission name="project:group:submit">
                    <input id="btnSubmit" class="btn btn-primary" type="submit" value="提交审批"
                           onclick="return setStatus(2);"/>
                    &nbsp;&nbsp;&nbsp;
                </shiro:hasPermission>
            </c:if>

            <c:if test="${aamsProject.status == 2}"> <%--2：未审批状态--%>
                <shiro:hasPermission name="project:group:status">
                    <input id="btnSubmit" class="btn btn-primary" type="submit" value="通过"
                           onclick="return setStatus(3)"/>
                    &nbsp;&nbsp;&nbsp;
                    <input id="btnSubmit" class="btn btn-warning" type="submit" value="驳回"
                           onclick="return setStatus(5)"/>
                    &nbsp;&nbsp;&nbsp;
                </shiro:hasPermission>
            </c:if>

            <shiro:hasPermission name="project:group:delete">
                <a class="btn btn-danger" href="${ctx}/project/group/delete?id=${aamsProject.id}"
                   onclick="return confirmx('确认要删除这个集团督办项目吗？', this.href)">删除</a>
            </shiro:hasPermission>

            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>

    </form:form>
</div>
</body>
</html>