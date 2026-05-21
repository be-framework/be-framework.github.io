<?php

declare(strict_types=1);

/**
 * Generate llms-full.txt from llms.txt and English manual markdown files.
 */

$baseDir = dirname(__DIR__);
$llmsFile = $baseDir . '/llms.txt';
$manualDir = $baseDir . '/manuals/1.0/en';
$outputFile = $baseDir . '/llms-full.txt';

if (! is_file($llmsFile)) {
    fwrite(STDERR, "llms.txt not found at {$llmsFile}\n");
    exit(1);
}

if (! is_dir($manualDir)) {
    fwrite(STDERR, "Manual directory not found at {$manualDir}\n");
    exit(1);
}

$skipFiles = [
    '1page.md' => true,
    'onepage.md' => true,
    'ai-assistant.md' => true,
];

$files = [];
$iterator = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($manualDir, FilesystemIterator::SKIP_DOTS),
);

foreach ($iterator as $file) {
    if (! $file instanceof SplFileInfo || $file->getExtension() !== 'md') {
        continue;
    }

    if (isset($skipFiles[$file->getBasename()])) {
        continue;
    }

    $files[] = $file->getPathname();
}

sort($files, SORT_STRING);

$llmsContent = file_get_contents($llmsFile);
if ($llmsContent === false) {
    fwrite(STDERR, "Failed to read llms.txt at {$llmsFile}\n");
    exit(1);
}

$content = rtrim($llmsContent) . "\n\n---\n\n# Full Documentation\n\n";

foreach ($files as $file) {
    $markdown = file_get_contents($file);
    if ($markdown === false) {
        fwrite(STDERR, "Failed to read markdown file at {$file}\n");
        exit(1);
    }

    $markdown = preg_replace('/\A---\s*\R.*?\R---\s*\R/ms', '', $markdown, 1) ?? $markdown;
    $markdown = trim($markdown);

    if ($markdown === '') {
        continue;
    }

    $relativePath = ltrim(str_replace($baseDir, '', $file), '/');
    $content .= "<!-- Source: {$relativePath} -->\n\n";
    $content .= $markdown . "\n\n";
}

$bytesWritten = file_put_contents($outputFile, $content);
if ($bytesWritten === false || $bytesWritten !== strlen($content)) {
    fwrite(STDERR, "Failed to write complete llms-full.txt to {$outputFile}\n");
    exit(1);
}

echo "Generated llms-full.txt successfully.\n";
echo 'Included files: ' . count($files) . "\n";
