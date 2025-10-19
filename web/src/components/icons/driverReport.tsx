import React from 'react';

export default function DriverReport({ className = 'w-5 h-5 text-gray-500' }: { className?: string }) {
return (
    <svg
    xmlns="http://www.w3.org/2000/svg"
    fill="none"
    viewBox="0 0 24 24"
    strokeWidth={1.8}
    stroke="currentColor"
    className={className}
    >
      {/* Head */}
    <circle cx="12" cy="8" r="3" />

      {/* Shoulders / torso */}
    <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M5 20c0-3.5 3-5 7-5s7 1.5 7 5"
    />

      {/* Document or clipboard background */}
    <rect
        x="3"
        y="3"
        width="18"
        height="18"
        rx="2"
        ry="2"
        strokeOpacity={0.3}
    />

      {/* Checklist lines */}
    <path strokeLinecap="round" d="M8 13h4M8 16h3" />
    </svg>
);
}
