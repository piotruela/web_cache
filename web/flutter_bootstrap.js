{{flutter_js}}
{{flutter_build_config}}

(async function() {
    const cacheControlMaxAge = 60; // Set cache to a short period (e.g., 60 seconds)

    async function fetchWithCacheControl(url) {
        const response = await fetch(url, {
            headers: {
                'Cache-Control': `max-age=${cacheControlMaxAge}, must-revalidate`
            },
            cache: 'no-store'  // Ensures the request bypasses the cache
        });
        return response;
    }

    // Example of preloading main resources
    const appResources = [
        'main.dart.js', 
        'index.html', 
        'flutter_service_worker.js'
    ];

    for (const resource of appResources) {
        try {
            const response = await fetchWithCacheControl(resource);
            if (!response.ok) throw new Error(`Failed to load ${resource}`);
            // Optionally, handle resource caching or other actions here
        } catch (error) {
            console.error(`Error loading ${resource}:`, error);
        }
    }

    // Start the Flutter app after setting up cache control
    _flutter.loader.load();
})();
