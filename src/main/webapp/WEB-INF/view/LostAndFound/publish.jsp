<%--
  Created by IntelliJ IDEA.
  User: linguancheng
  Date: 2017/11/6
  Time: 21:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport"
          content="width=device-width,initial-scale=1.0,user-scalable=no,minimum-scale=1.0,maximum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="MobileOptimized" content="320">
    <meta name="format-detection" content="telephone=no"/>
    <link rel="stylesheet" type="text/css" href="/css/common/weui-1.1.1.min.css">
    <link rel="stylesheet" type="text/css" href="/css/common/weui-0.2.2.min.css">
    <link rel="stylesheet" type="text/css" href="/css/lostandfound/publish.css">
    <title>广东第二师范学院失物招领</title>
    <script type="text/javascript" src="/js/common/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="/js/common/weui.min.js"></script>
    <script type="application/javascript" src="/js/common/fastclick.js"></script>
    <script type="text/javascript">

        //消除iOS点击延迟
        $(function () {
            FastClick.attach(document.body);
        });

        // 允许上传的图片类型
        var allowTypes = ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'];

        // 图片最大大小为5MB
        var maxSize = 1024 * 1024 * 5;

        // 图片最大宽度
        var maxWidth = 720;

        //临时存放图片的Base64编码数组
        var images = new Array(4);

        //当前图片游标
        var imagesCount = 0;

        // 这个图片展示规则是宽大于高按高100%截宽，高大于宽按宽100%截高；默认是宽100%截高
        window.checkimg = function (obj) {
            if (obj.width > obj.height) {
                obj.style.width = 'auto';
                obj.style.height = '100%';
            }
        };

        $(function () {

                // 如果屏幕宽度小于375px，按320px宽的页面缩小
                if (window.innerWidth < 375) {
                    $('.picture .images').addClass('forp4');
                }

                var ua = window.navigator.userAgent;
                if (!(/\(i[^;]+;( U;)? CPU.+Mac OS X/).test(ua) && ua.indexOf('Android') === -1 && ua.indexOf('Linux') === -1) {
                    $('body').addClass('isPC');
                }

                // 选择商品分类
                $('#selectType').click(function () {
                    $('.sky').show();
                    $('.sky .mark').show();
                    $('.typemw').show();
                    $('html').css({
                        'height': '100%',
                        'overflow': 'hidden'
                    });
                });

                $('.mw .mwclose').click(function (e) {
                    $(e.currentTypt).closest('.mw').hide();
                    $('.sky').hide();
                    $('.sky .mark').hide();
                    $('html').css({
                        'height': 'auto',
                        'overflow': 'auto'
                    });
                });

                $(".which").on("click", "label", function () {
                    if ($(this).index() == 0) {
                        $(".place").text("丢失地点");
                    } else {
                        $(".place").text("捡到地点");
                    }
                });

                // 提交二手交易信息
                $(".submit").click(function () {
                    // 检查有无选择图片
                    if (imagesCount < 1) {
                        showErrorTip("请至少选择一张图片");
                    }
                    //检查输入内容合法性
                    else if (parseInt($("input[name='lostType']:checked").val()) < 0 || parseInt($("input[name='lostType']:checked").val()) > 1) {
                        showErrorTip("不合法的寻找类型");
                    }
                    else if ($("#name").val() == '' && $("#name").val().length > 25) {
                        showErrorTip("物品名称长度不合法");
                    }
                    else if ($("#description").val() == '' && $("#description").val().length > 100) {
                        showErrorTip("物品描述长度不合法");
                    }
                    else if ($("#location").val() == '' && $("#location").val().length > 30) {
                        showErrorTip("地点长度不合法");
                    }
                    else if (parseInt($("#itemType").val()) < 0 || parseInt($("#itemType").val()) > 11) {
                        showErrorTip("不合法的物品分类")
                    }
                    else if ($("#qq").val() == '' && $("#wechat").val() == '' && $("#phone").val() == '') {
                        showErrorTip("联系方式至少需要填写一项");
                    }
                    else if ($("#qq").val().length > 20) {
                        showErrorTip("不合法的QQ号码");
                    }
                    else if ($("#wechat").val().length > 20) {
                        showErrorTip("不合法的微信号");
                    }
                    else if ($("#phone").val().length > 11) {
                        showErrorTip("不合法的手机号码");
                    }
                    else {

                        var formData = new FormData();

                        for (var i = 0; i < imagesCount; i++) {

                            var canvas = document.createElement('canvas');
                            var ctx = canvas.getContext('2d');
                            var image = new Image();
                            image.src = images[i];
                            // 设置 canvas 的宽度和高度
                            canvas.width = image.width;
                            canvas.height = image.height;
                            ctx.drawImage(image, 0, 0, image.width, image.height);
                            var base64 = canvas.toDataURL('image/jpeg', 1);

                            base64 = base64.split(',')[1];
                            base64 = window.atob(base64);
                            var ia = new Uint8Array(base64.length);
                            for (var j = 0; j < base64.length; j++) {
                                ia[j] = base64.charCodeAt(j);
                            }
                            formData.append('image' + (i + 1), new Blob([ia], {type: "image/jpg"}));
                        }
                        formData.append('lostType', $("input[name='lostType']:checked").val());
                        formData.append('name', $("#name").val());
                        formData.append('description', $("#description").val());
                        formData.append('location', $("#location").val());
                        formData.append('itemType', $("#itemType").val());
                        if ($("#qq").val() != '') {
                            formData.append('qq', $("#qq").val());
                        }
                        if ($("#wechat").val() != '') {
                            formData.append('wechat', $("#wechat").val());
                        }
                        if ($("#phone").val() !== '') {
                            formData.append('phone', $("#phone").val());
                        }

                        //防止用户重复点击提交
                        $(".submit").attr("disabled", true);

                        //显示等待动画
                        var loading = weui.loading('提交中');

                        $.ajax({
                            url: '/rest/lostandfound/info',
                            type: 'post',
                            data: formData,
                            processData: false,
                            contentType: false,
                            success: function (result) {
                                if (result.success === true) {
                                    if (parseInt($("#lostType").val()) == 0) {
                                        window.location.href = '/lostandfound/lost';
                                    }
                                    else {
                                        window.location.href = '/lostandfound/found';
                                    }
                                }
                                else {
                                    $(".submit").attr("disabled", false);
                                    loading.hide();
                                    showErrorTip(result.errorMessage);
                                }
                            },
                            error: function () {
                                $(".submit").attr("disabled", false);
                                loading.hide();
                                showErrorTip("网络异常，请检查网络连接");
                            }
                        });
                    }
                });

                // 选择分类后修改隐藏的Input属性值
                $(".mwc ul li a").click(function () {
                    $(".selectvalue").text($(this).text());
                    $("input[name='itemType']").val($(this).closest("li").index());
                    $(this).closest('.mw').hide();
                    $('.sky').hide();
                    $('.sky .mark').hide();
                    $('html').css({
                        'height': 'auto',
                        'overflow': 'auto'
                    });
                });

                // 删除图片
                $("body").on("click", ".iclose", function () {
                    $(this).closest(".image").remove();
                    var id = parseInt($(this).attr("id"));
                    for (var i = id; i < imagesCount - 1; i++) {
                        images[i] = images[i + 1];
                    }
                    images[imagesCount - 1] = undefined;
                    imagesCount--;
                });

                // 缓存图片
                $("#file_input").on("change", function (event) {

                    var files = event.target.files;

                    // 如果没有选中文件，直接返回
                    if (files.length === 0) {
                        return;
                    }

                    var file = files[0];
                    var reader = new FileReader();

                    // 如果类型不在允许的类型范围内
                    if (allowTypes.indexOf(file.type) === -1) {
                        showErrorTip("不合法的图片文件类型", "上传错误");
                        return;
                    }

                    if (file.size > maxSize) {
                        showErrorTip("图片文件不能超过5MB", "文件过大");
                        return;
                    }

                    if ($(".upimg").length >= 4) {
                        showErrorTip("最多只能选择四张图片！");
                    }
                    else {

                        reader.readAsDataURL(file);

                        reader.onload = function (e) {

                            var img = new Image();
                            img.src = e.target.result;

                            img.onload = function () {

                                // 不要超出最大宽度
                                var w = Math.min(maxWidth, img.width);
                                // 高度按比例计算
                                var h = img.height * (w / img.width);
                                var canvas = document.createElement('canvas');
                                var ctx = canvas.getContext('2d');
                                // 设置 canvas 的宽度和高度
                                canvas.width = w;
                                canvas.height = h;
                                ctx.drawImage(img, 0, 0, w, h);

                                // 返回一个包含图片展示的 Data URI
                                var base64 = canvas.toDataURL('image/jpeg', 0.8);

                                // 缓存图片Base64编码
                                images[imagesCount] = base64;

                                $(".addimg").before("<div class='image'><a href='#'><i id='" + imagesCount + "' class='i iclose'></i></a><i class='img'><img src='" + base64 + "' onload='window.checkimg(this)'></i><input name='imgs[]' class='upimg' hidden></div>");

                                imagesCount++;
                            }
                        };
                    }
                });
            }
        );

        // 显示错误提示
        function showErrorTip(errorMessage) {
            $(".weui_warn").text(errorMessage).show().delay(2000).hide(0);
        }

    </script>
</head>

<body class="body1">

<form id="form">

    <section class="head">
        <p class="opt"><a href="#" class="submit">完成</a></p>
        <a href="javascript:history.go(-1);" class="back"><i class="i iarr"></i></a>
        <span class="t2">发布失物招领信息</span>
    </section>

    <section class="picture">
        <div class="images">
                <span class="addimg">
            <i class="i iadd"><i class="i i1"></i><i class="i i2"></i></i>
            <input type="file" accept="image/*" id="file_input" name="file[]">
                </span>
        </div>
        <p class="tip">最多可上传4张图片</p>
    </section>

    <section class="form">
        <div class="frm">
            <p class="frmt">寻找类型</p>
            <div class="which">
                <label>
                    <input type="radio" name="lostType" value="0" checked>寻物
                </label>
                <label>
                    <input type="radio" name="lostType" value="1">寻主
                </label>
            </div>
        </div>
        <div class="frm">
            <p class="frmt">物品名称</p>
            <div class="frmc">
                <input id="name" type="text" placeholder="最多25个字" name="name" maxlength="25">
            </div>
        </div>
        <div class="frm">
            <p class="frmt">物品描述</p>
            <div class="frmc">
                <input id="description" type="text" name="description" maxlength="=100">
            </div>
        </div>
        <div class="frm">
            <p class="frmt place">丢失地点</p>
            <div class="frmc">
                <input id="location" type="text" name="location" maxlength="30">
            </div>
        </div>
        <div class="frm">
            <p class="frmt select">选择分类</p>
            <div class="frmc"><b id="selectType"><span class="selectvalue"></span><i class="i iarrow"></i></b></div>
            <input id="itemType" type="hidden" name="itemType">
        </div>

        <!-- 联系方式 -->
        <div class="contact_tip">QQ号/微信/手机号任填其中一项即可</div>
        <div class="frm">
            <p class="frmt">QQ号</p>
            <div class="frmc">
                <input id="qq" type="text" name="qq" value="" maxlength="20">
            </div>
        </div>
        <div class="frm">
            <p class="frmt">微信号</p>
            <div class="frmc">
                <input id="wechat" type="text" name="wechat" value="" maxlength="20">
            </div>
        </div>
        <div class="frm">
            <p class="frmt">手机号</p>
            <div class="frmc">
                <input id="phone" type="text" name="phone" value="" maxlength="11">
            </div>
        </div>

        <br><br>
    </section>
</form>

<!-- 错误提示，显示时用$.show();隐藏时用$.hide(); -->
<div class="weui_toptips weui_warn js_tooltips"></div>

<div class="sky">
    <div class="mark"></div>
    <div class="mw typemw">

        <div class="mwt">
            <a href="javascript:" class="mwclose"><i class="i imwclose"></i></a>
            <p>选择分类</p>
        </div>

        <div class="mwc">
            <ul>
                <li><a href="javascript:">手机</a></li>
                <li><a href="javascript:">校园卡</a></li>
                <li><a href="javascript:">身份证</a></li>
                <li><a href="javascript:">银行卡</a></li>
                <li><a href="javascript:">书</a></li>
                <li><a href="javascript:">钥匙</a></li>
                <li><a href="javascript:">包包</a></li>
                <li><a href="javascript:">衣帽</a></li>
                <li><a href="javascript:">校园代步</a></li>
                <li><a href="javascript:">运动健身</a></li>
                <li><a href="javascript:">数码配件</a></li>
                <li><a href="javascript:">其他</a></li>
            </ul>
        </div>

    </div>
</div>

</body>

</html>
