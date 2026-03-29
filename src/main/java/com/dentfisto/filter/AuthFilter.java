package com.dentfisto.filter;

import com.dentfisto.model.Utilisateur;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Intercepts all requests.
 * - Public paths (login pages, CSS, JS) are always allowed.
 * - Role-specific paths (/admin/*, /dentist/*, /assistant/*) require the matching role.
 * - Unauthenticated users are redirected to the root page.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Allow public resources
        if (isPublic(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Check authentication
        HttpSession session = req.getSession(false);
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        // Check role authorization for protected paths
        if (path.startsWith("/admin/") && !"ADMINISTRATEUR".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        if (path.startsWith("/dentist/") && !"DENTISTE".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        if (path.startsWith("/assistant/") && !"ASSISTANTE".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        chain.doFilter(request, response);
    }

    /**
     * Returns true if the path does not require authentication.
     */
    private boolean isPublic(String path) {
        return path.equals("/")
            || path.equals("")
            || path.startsWith("/login")
            || path.startsWith("/css/")
            || path.startsWith("/js/")
            || path.startsWith("/images/")
            || path.equals("/logout");
    }

    @Override
    public void destroy() {}
}
