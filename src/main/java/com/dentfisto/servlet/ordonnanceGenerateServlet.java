
// ───────────────────────────────────────────────────────────────────────
// FILE 9: OrdonnanceGenerateServlet.java  ← OpenPDF implementation
// URL:    POST /dentist/ordonnance/generate
// Body:   JSON { rvId, patientName, doctorName, date, medications:[] }
// Returns: application/pdf (binary download)
// ───────────────────────────────────────────────────────────────────────
package com.dentfisto.servlet;

import com.dentfisto.model.Document;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.awt.Color;
import java.awt.Font;
import java.awt.Rectangle;
import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

import javax.lang.model.element.Element;

@WebServlet("/dentist/ordonnance/generate")
public class ordonnanceGenerateServlet extends HttpServlet {

    private static final DateTimeFormatter FR_DATE = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        req.setCharacterEncoding("UTF-8");

        // ── Parse JSON body manually (no Gson required for this simple structure) ──
        String body = readBody(req);
        String patientName = extractJson(body, "patientName");
        String doctorName = extractJson(body, "doctorName");
        String dateStr = extractJson(body, "date");
        List<String> meds = extractJsonArray(body, "medications");

        if (meds.isEmpty()) {
            resp.setStatus(400);
            resp.getWriter().write("{\"error\":\"No medications provided\"}");
            return;
        }

        // ── Generate PDF with OpenPDF ──
        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition",
                "attachment; filename=\"Ordonnance_" +
                        patientName.replace(" ", "_") + "_" +
                        LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + ".pdf\"");

        try {
            Document doc = new Document(PageSize.A4, 60, 60, 70, 70);
            PdfWriter.getInstance(doc, resp.getOutputStream());
            doc.open();

            // ── Fonts ──
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16, Color.decode("#0f1923"));
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, Color.decode("#0f1923"));
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 10, Color.decode("#374151"));
            Font smallFont = FontFactory.getFont(FontFactory.HELVETICA, 9, Color.decode("#6b7280"));
            Font medFont = FontFactory.getFont(FontFactory.HELVETICA, 11, Color.decode("#1e293b"));
            Font medNumFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, Color.decode("#1a6fa8"));

            // ── Header table ──
            PdfPTable headerTable = new PdfPTable(2);
            headerTable.setWidthPercentage(100);
            headerTable.setSpacingAfter(20);

            // Cabinet info (left)
            PdfPCell leftCell = new PdfPCell();
            leftCell.setBorder(Rectangle.NO_BORDER);
            leftCell.setPadding(0);
            leftCell.addElement(new Paragraph("DentFisto – Cabinet Dentaire", headerFont));
            leftCell.addElement(new Paragraph(
                    (doctorName != null ? doctorName : "Dr. Martin") + " · Chirurgien-Dentiste", normalFont));
            leftCell.addElement(new Paragraph("Tél: 05 22 XX XX XX", smallFont));
            headerTable.addCell(leftCell);

            // Ordonnance label (right)
            PdfPCell rightCell = new PdfPCell();
            rightCell.setBorder(Rectangle.NO_BORDER);
            rightCell.setPadding(0);
            rightCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            Paragraph ordTitle = new Paragraph("ORDONNANCE MÉDICALE", titleFont);
            ordTitle.setAlignment(Element.ALIGN_RIGHT);
            rightCell.addElement(ordTitle);
            Paragraph dateP = new Paragraph(dateStr != null ? dateStr : LocalDate.now().format(FR_DATE), smallFont);
            dateP.setAlignment(Element.ALIGN_RIGHT);
            rightCell.addElement(dateP);
            Paragraph numP = new Paragraph("N° " + (int) (Math.random() * 9000 + 1000), smallFont);
            numP.setAlignment(Element.ALIGN_RIGHT);
            rightCell.addElement(numP);
            headerTable.addCell(rightCell);

            doc.add(headerTable);

            // ── Separator ──
            LineSeparator ls = new LineSeparator(1f, 100f, Color.decode("#e2e8f0"), Element.ALIGN_CENTER, 0);
            doc.add(new Chunk(ls));
            doc.add(new Paragraph(" "));

            // ── Patient line ──
            Paragraph patLine = new Paragraph();
            patLine.add(new Chunk("Pour le patient : ", normalFont));
            patLine.add(new Chunk(patientName != null ? patientName : "Patient", headerFont));
            patLine.setSpacingAfter(16);
            doc.add(patLine);

            // ── Medications ──
            Paragraph medsTitle = new Paragraph("Prescriptions :", headerFont);
            medsTitle.setSpacingAfter(10);
            doc.add(medsTitle);

            for (int i = 0; i < meds.size(); i++) {
                PdfPTable medRow = new PdfPTable(new float[] { 0.06f, 0.94f });
                medRow.setWidthPercentage(100);
                medRow.setSpacingAfter(6);

                PdfPCell numCell = new PdfPCell(new Phrase(String.valueOf(i + 1) + ".", medNumFont));
                numCell.setBorder(Rectangle.NO_BORDER);
                numCell.setPaddingTop(4);

                PdfPCell textCell = new PdfPCell(new Phrase(meds.get(i), medFont));
                textCell.setBorder(Rectangle.BOTTOM);
                textCell.setBorderColor(Color.decode("#f1f5f9"));
                textCell.setPaddingBottom(8);

                medRow.addCell(numCell);
                medRow.addCell(textCell);
                doc.add(medRow);
            }

            // ── Signature ──
            doc.add(new Paragraph("\n\n\n"));
            PdfPTable sigTable = new PdfPTable(2);
            sigTable.setWidthPercentage(100);

            PdfPCell spacer = new PdfPCell(new Phrase(" "));
            spacer.setBorder(Rectangle.NO_BORDER);
            sigTable.addCell(spacer);

            PdfPCell sigCell = new PdfPCell();
            sigCell.setBorder(Rectangle.TOP);
            sigCell.setBorderColor(Color.decode("#94a3b8"));
            sigCell.setPaddingTop(8);
            sigCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            sigCell.addElement(new Paragraph("Signature & Cachet du Praticien", smallFont));
            sigTable.addCell(sigCell);

            doc.add(sigTable);

            // ── Footer ──
            doc.add(new Paragraph("\n"));
            Paragraph footer = new Paragraph(
                    "Document généré par DentFisto – " + LocalDate.now().format(FR_DATE), smallFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            doc.add(footer);

            doc.close();

            // TODO: also save ordonnance to DB:
            // INSERT INTO ordonnance (rv_id, patient_id, dentiste_id, medicaments_json,
            // chemin_pdf, date_generation)
            // VALUES (?, ?, ?, ?, ?, NOW())

        } catch (DocumentException ex) {
            throw new IOException("PDF generation failed: " + ex.getMessage(), ex);
        }
    }

    // ── Minimal JSON helpers (replace with Gson in production) ──

    private String extractJson(String json, String key) {
        String search = "\"" + key + "\":\"";
        int start = json.indexOf(search);
        if (start < 0)
            return null;
        start += search.length();
        int end = json.indexOf("\"", start);
        return end > start ? json.substring(start, end) : null;
    }

    private List<String> extractJsonArray(String json, String key) {
        List<String> result = new ArrayList<>();
        String search = "\"" + key + "\":[";
        int start = json.indexOf(search);
        if (start < 0)
            return result;
        start += search.length();
        int end = json.indexOf("]", start);
        if (end < 0)
            return result;
        String arr = json.substring(start, end);
        for (String item : arr.split(",")) {
            String clean = item.trim().replaceAll("^\"|\"$", "");
            if (!clean.isBlank())
                result.add(clean);
        }
        return result;
    }

    private String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader r = req.getReader()) {
            String line;
            while ((line = r.readLine()) != null)
                sb.append(line);
        }
        return sb.toString();
    }
}