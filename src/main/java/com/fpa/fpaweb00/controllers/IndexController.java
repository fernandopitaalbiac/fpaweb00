package com.fpa.fpaweb00.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller
public class IndexController {

    @GetMapping({"/", "/index"})
    public String index(Model model) {
        // Mensaje básico
        model.addAttribute("mensaje", "Hola mundo");

        // Fecha y hora actuales formateadas
        String fechaHora = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss"));
        model.addAttribute("fechaHora", fechaHora);

        // Renderiza la plantilla index.html
        return "index";
    }
}
