package com.dentfisto.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

/**
 * Utility class for sending emails using Gmail SMTP.
 */
public class EmailUtil {

    private static final String FROM_EMAIL = "tt01taha01@gmail.com";
    // IMPORTANT: Use a Gmail "App Password", NOT your regular password.
    // Generate one at: https://myaccount.google.com/apppasswords (2FA must be
    // enabled)
    // A 16-char code like "abcd efgh ijkl mnop" (without spaces)
    private static final String FROM_PASSWORD = "bkbn zqgg vjuo ujut";

    /**
     * Send an HTML email to the given recipient.
     *
     * @param toEmail  recipient email address
     * @param subject  email subject
     * @param htmlBody HTML content of the email body
     * @return true if sent successfully, false otherwise
     */
    public static boolean sendEmail(String toEmail, String subject, String htmlBody) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "DentFisto Clinique"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("[EmailUtil] Email sent successfully to " + toEmail);
            return true;
        } catch (Exception e) {
            System.err.println("[EmailUtil] Failed to send email to " + toEmail + " : " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
