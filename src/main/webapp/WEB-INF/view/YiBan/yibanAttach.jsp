<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: linguancheng
  Date: 2017/11/16
  Time: 23:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>易班-绑定教务系统账号</title>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport">
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="black" name="apple-mobile-web-app-status-bar-style">
    <meta content="telephone=no" name="format-detection">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <!-- 如果使用双核浏览器，强制使用webkit来进行页面渲染 -->
    <meta name="renderer" content="webkit"/>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
    <link rel="stylesheet" href="/css/common/common.css">
    <link rel="stylesheet" href="/css/common/weui-1.1.1.min.css">
    <link rel="stylesheet" href="/css/common/weui-0.2.2.min.css">
    <script type="text/javascript" src="/js/common/jquery-3.2.1.min.js"></script>
    <script type="application/javascript" src="/js/common/fastclick.js"></script>
    <script type="text/javascript">

        //消除iOS点击延迟
        $(function () {
            FastClick.attach(document.body);
        });

        //提交表单数据登录
        function postLoginForm() {
            if ($("#username").val() === "" || $("#password").val() === "") {
                $(".weui_warn").text("请将信息填写完整！").show().delay(2000).hide(0);
            }
            else {
                $("#loadingToast, .weui_mask").show();
                $.ajax({
                    url: "/yiban/userattach",
                    data: {
                        username: $("#username").val(),
                        password: $("#password").val()
                    },
                    type: 'post',
                    success: function (yibanAttachResult) {
                        //隐藏进度条
                        $("#loadingToast, .weui_mask").hide();
                        if (yibanAttachResult.success === true) {
                            //绑定易班教务系统账号成功
                            <c:choose>
                            <c:when test="${RedirectURL!=null}">
                            window.location.href = '${RedirectURL}';
                            </c:when>
                            <c:otherwise>
                            window.location.href = '/index';
                            </c:otherwise>
                            </c:choose>
                        }
                        else {
                            //显示绑定失败信息提示
                            $(".weui_warn").text(yibanAttachResult.errorMessage).show().delay(2000).hide(0);
                        }
                    },
                    error: function () {
                        //隐藏进度条
                        $("#loadingToast, .weui_mask").hide();
                        $(".weui_warn").text("绑定教务系统账号失败,请检查网络连接！").show().delay(2000).hide(0);
                    }
                });
            }
        }

    </script>
</head>
<body>

<div class="hd">
    <h1 class="page_title">绑定教务系统</h1>
    <p class="page_desc">请登录教务系统</p>
</div>

<!-- 提交的用户信息表单 -->
<div class="weui_cells weui_cells_form">
    <form>
        <div class="weui_cell">
            <div class="weui_cell_hd">
                <label class="weui_label">账号</label>
            </div>
            <div class="weui_cell_bd weui_cell_primary">
                <input id="username" class="weui_input" type="text" maxlength="20" name="username"
                       placeholder="请输入你的教务系统账号">
            </div>
        </div>
        <div class="weui_cell">
            <div class="weui_cell_hd">
                <label class="weui_label">密码</label>
            </div>
            <div class="weui_cell_bd weui_cell_primary">
                <input id="password" class="weui_input" type="password" maxlength="35" name="password"
                       placeholder="请输入你的教务系统密码">
            </div>
        </div>
    </form>
</div>

<!-- 登录按钮 -->
<div class="weui_btn_area">
    <a class="weui_btn weui_btn_primary" href="javascript:" onclick="postLoginForm()">登录</a>
</div>

<!-- 登录中弹框 -->
<div class="weui_mask" style="display: none"></div>
<div id="loadingToast" class="weui_loading_toast" style="display: none">
    <div class="weui_mask_transparent"></div>
    <div class="weui_toast">
        <div class="weui_loading">
            <div class="weui_loading_leaf weui_loading_leaf_0"></div>
            <div class="weui_loading_leaf weui_loading_leaf_1"></div>
            <div class="weui_loading_leaf weui_loading_leaf_2"></div>
            <div class="weui_loading_leaf weui_loading_leaf_3"></div>
            <div class="weui_loading_leaf weui_loading_leaf_4"></div>
            <div class="weui_loading_leaf weui_loading_leaf_5"></div>
            <div class="weui_loading_leaf weui_loading_leaf_6"></div>
            <div class="weui_loading_leaf weui_loading_leaf_7"></div>
            <div class="weui_loading_leaf weui_loading_leaf_8"></div>
            <div class="weui_loading_leaf weui_loading_leaf_9"></div>
            <div class="weui_loading_leaf weui_loading_leaf_10"></div>
            <div class="weui_loading_leaf weui_loading_leaf_11"></div>
        </div>
        <p class="weui_toast_content">登录中</p>
    </div>
</div>

<!-- 错误提示，显示时用$.show();隐藏时用$.hide(); -->
<div class="weui_toptips weui_warn js_tooltips"></div>

<p class="page_desc" style="margin-top: 25px">点击登录按钮表示你已阅读并同意
    <a class="page_desc" onclick="window.location.href = '/agreement'" style="color: #3cc51f;">《用户协议》
    </a>
</p>

<div class="weui_msg">

    <div class="weui_extra_area">
        <p>关注微信公众号【广东二师助手】</p>
        <p>获取更多资讯，下载广二师助手APP客户端</p>
    </div>

</div>

</body>
</html>