// Prime Codex Navigation

document.addEventListener('DOMContentLoaded', function() {
    // Smooth scrolling
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });

    // Highlight current page in nav
    const currentPage = window.location.pathname.split('/').pop();
    document.querySelectorAll('nav a').forEach(link => {
        if (link.getAttribute('href') === currentPage) {
            link.style.background = 'rgba(255,255,255,0.2)';
            link.style.borderLeft = '4px solid var(--prime-17)';
        }
    });

    // Add copy buttons to code blocks
    document.querySelectorAll('pre').forEach(pre => {
        const button = document.createElement('button');
        button.textContent = '📋 Copy';
        button.style.cssText = 'position: absolute; top: 5px; right: 5px; padding: 5px 10px; background: #444; border: none; color: white; cursor: pointer; border-radius: 3px;';
        pre.style.position = 'relative';
        pre.appendChild(button);

        button.addEventListener('click', () => {
            const code = pre.querySelector('code') || pre;
            navigator.clipboard.writeText(code.textContent);
            button.textContent = '✅ Copied!';
            setTimeout(() => button.textContent = '📋 Copy', 2000);
        });
    });
});
