package com.xz.wlw.controller;

import com.xz.wlw.util.Result;
import com.xz.wlw.util.ResultGenerator;
import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

/**
 * Created by 13 on 2017/4/7.
 */
@Controller
public class LoadImageController {

    /**
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/uploadImages", method = RequestMethod.POST)
    @ResponseBody
    public Result upload(HttpServletRequest request, @RequestParam("file") MultipartFile file) throws Exception {
        System.out.println("图片上传啦");
        ServletContext sc = request.getSession().getServletContext();
        String dir = sc.getRealPath("/upload");
        String type = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".") + 1, file.getOriginalFilename().length());

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        Random r = new Random();
        String imgName = "";
        if (type.equals("jpg")) {
            imgName = sdf.format(new Date()) + r.nextInt(100) + ".jpg";
        } else if (type.equals("png")) {
            imgName = sdf.format(new Date()) + r.nextInt(100) + ".png";
        } else if (type.equals("jpeg")) {
            imgName = sdf.format(new Date()) + r.nextInt(100) + ".jpeg";
        } else {
            return null;
        }
        FileUtils.writeByteArrayToFile(new File(dir, imgName), file.getBytes());
        Result result = ResultGenerator.genSuccessResult();
        result.setData("upload/" + imgName);
        return result;
    }

    @RequestMapping(value = "/uploadFile", method = RequestMethod.POST)
    @ResponseBody
    public Result uploadFile(HttpServletRequest request, @RequestParam("file") MultipartFile file) throws Exception {
        System.out.println("文件上传啦");
        ServletContext sc = request.getSession().getServletContext();
        String dir = sc.getRealPath("/upload");
        String type = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".") + 1, file.getOriginalFilename().length());

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        Random r = new Random();
        String imgName = "";
        imgName=sdf.format(new Date()) + r.nextInt(100)+"."+type;
//        if (type.equals("zip")) {
//            imgName = sdf.format(new Date()) + r.nextInt(100) + ".zip";
//        } else if (type.equals("word")) {
//            imgName = sdf.format(new Date()) + r.nextInt(100) + ".word";
//        } else if (type.equals("ppt")) {
//            imgName = sdf.format(new Date()) + r.nextInt(100) + ".ppt";
//        } else {
//            return null;
//        }
        FileUtils.writeByteArrayToFile(new File(dir, imgName), file.getBytes());
        Result result = ResultGenerator.genSuccessResult();
        result.setData("upload/" + imgName);
        return result;
    }
}