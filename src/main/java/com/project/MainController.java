package com.project;

import lombok.extern.log4j.Log4j;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


@Controller
@Log4j
public class MainController {

    @RequestMapping(value = "/")
    public ModelAndView index(ModelAndView mv){
        mv.setViewName("index");
        return mv;
    }

    /*@RequestMapping(value = "/mainPage")
    public String mainPage() {
        return "common/mainPage";
    }*/

    @RequestMapping(value = "/mainPage")
    public String getStockPrice(Model model) throws IOException {

        String url = "https://land.naver.com/news/region.naver?page=1";

        Document doc = Jsoup.connect(url).get();

        Elements e1 = doc.getElementsByAttributeValue("class", "section_headline");
        Element e2 = e1.get(0);

        Elements photoElements = e2.getElementsByAttributeValue("class", "photo");

        //ArrayList<String> newsTitle = new ArrayList<>();
        //ArrayList<String> newsUrl= new ArrayList<>();

        ArrayList<HashMap> newsList = new ArrayList();

        for(int i = 0; i< 4; i++){
            Element articleElement = photoElements.get(i);
            Elements aElements = articleElement.select("a");
            Element aElement = aElements.get(0);

            String articleUrl = "https://land.naver.com"+aElement.attr("href"); // 기사링크

            Element imgElement = aElement.select("img").get(0);
            String title = imgElement.attr("alt"); //기사제목

            System.out.println(title);
            System.out.println(articleUrl);

            HashMap<String,String> newsInfo = new HashMap<>();
            newsInfo.put("newsTitle" , title);
            newsInfo.put("newsUrl",articleUrl);
            newsList.add(newsInfo);
            //newsTitle.add(title);
            //newsUrl.add(articleUrl);
        }

        model.addAttribute("newsList",newsList);

        //model.addAttribute("newsTitle", newsTitle);
        //model.addAttribute("newsUrl", newsUrl);

        return "common/mainPage";
    }


}






