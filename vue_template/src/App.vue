<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
/* ========================================
   Material You Design System
   Dynamic color system · playful shapes ·
   rounded corners · elevation shadows · responsive accents
   ======================================== */

:root {
  /* Primary Color Palette - Dynamic Tonal */
  --md-primary: #6750A4;
  --md-primary-light: #EADDFF;
  --md-primary-container: #E8DEF8;
  --md-on-primary: #FFFFFF;
  --md-on-primary-container: #21005D;

  /* Secondary Color - Warm Tones */
  --md-secondary: #7D5260;
  --md-secondary-light: #FFD8E4;
  --md-secondary-container: #FFD8E4;
  --md-on-secondary: #FFFFFF;
  --md-on-secondary-container: #31111D;

  /* Tertiary - Accent Color (Travel Theme) */
  --md-tertiary: #006B5B;
  --md-tertiary-light: #9CF4DC;
  --md-tertiary-container: #9CF4DC;
  --md-on-tertiary: #FFFFFF;
  --md-on-tertiary-container: #00201A;

  /* Custom Theme - Travel Orange */
  --md-theme: #C77800;
  --md-theme-light: #FFDEAC;
  --md-theme-container: #FFDEA8;
  --md-on-theme: #FFFFFF;
  --md-on-theme-container: #271900;

  /* Surface & Background */
  --md-surface: #FFFBFE;
  --md-surface-dim: #DED8E1;
  --md-surface-bright: #FFFBFE;
  --md-surface-container-lowest: #FFFFFF;
  --md-surface-container-low: #F7F2FA;
  --md-surface-container: #F3EDF7;
  --md-surface-container-high: #ECE6F0;
  --md-surface-container-highest: #E6E0E9;
  --md-surface-variant: #E7E0EC;
  --md-on-surface: #1C1B1F;
  --md-on-surface-variant: #49454F;

  /* Outline */
  --md-outline: #79747E;
  --md-outline-variant: #CAC4D0;

  /* Error */
  --md-error: #B3261E;
  --md-error-container: #F9DEDC;
  --md-on-error: #FFFFFF;
  --md-on-error-container: #410E0B;

  /* Shadows - Elevation */
  --md-elevation-1: 0px 1px 3px 1px rgba(0, 0, 0, 0.15), 0px 1px 2px rgba(0, 0, 0, 0.3);
  --md-elevation-2: 0px 2px 6px 2px rgba(0, 0, 0, 0.15), 0px 1px 2px rgba(0, 0, 0, 0.3);
  --md-elevation-3: 0px 4px 8px 3px rgba(0, 0, 0, 0.15), 0px 1px 3px rgba(0, 0, 0, 0.3);
  --md-elevation-4: 0px 6px 10px 4px rgba(0, 0, 0, 0.15), 0px 2px 3px rgba(0, 0, 0, 0.3);
  --md-elevation-5: 0px 8px 12px 6px rgba(0, 0, 0, 0.15), 0px 4px 4px rgba(0, 0, 0, 0.3);

  /* Corner Radius */
  --md-corner-none: 0px;
  --md-corner-extra-small: 4px;
  --md-corner-small: 8px;
  --md-corner-medium: 12px;
  --md-corner-large: 16px;
  --md-corner-extra-large: 28px;
  --md-corner-full: 50%;

  /* Transition */
  --md-transition-standard: cubic-bezier(0.2, 0, 0, 1);
  --md-transition-emphasized: cubic-bezier(0.2, 0, 0, 1);
  --md-transition-duration-short: 200ms;
  --md-transition-duration-medium: 400ms;
  --md-transition-duration-long: 500ms;
}

html, body {
  margin: 0;
  padding: 0;
  height: 100%;
  background: linear-gradient(135deg, #FFFBFE 0%, #F7F2FA 50%, #FCF4E8 100%);
  background-attachment: fixed;
}

#app {
  font-family: 'Google Sans', 'Roboto', 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB',
    'Microsoft YaHei', Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: var(--md-on-surface);
  height: 100%;
}

/* ========================================
   Material You Button Styles
   ======================================== */
.el-button--primary {
  background: var(--md-theme) !important;
  border-color: var(--md-theme) !important;
  border-radius: var(--md-corner-extra-large) !important;
  font-weight: 500;
  letter-spacing: 0.1px;
  transition: all var(--md-transition-duration-short) var(--md-transition-standard);
  box-shadow: var(--md-elevation-1);
}

.el-button--primary:hover {
  background: #A66400 !important;
  border-color: #A66400 !important;
  box-shadow: var(--md-elevation-2);
  transform: translateY(-1px);
}

.el-button--primary:active {
  box-shadow: var(--md-elevation-1);
  transform: translateY(0);
}

.el-button--primary.is-plain {
  color: var(--md-theme) !important;
  background: var(--md-theme-light) !important;
  border-color: transparent !important;
}

.el-button--primary.is-plain:hover {
  color: #A66400 !important;
  background: #FFE8C4 !important;
}

/* ========================================
   Material You Card Styles
   ======================================== */
.card-style,
.el-card {
  background: var(--md-surface-container-low) !important;
  border-radius: var(--md-corner-extra-large) !important;
  border: none !important;
  box-shadow: var(--md-elevation-1);
  transition: all var(--md-transition-duration-medium) var(--md-transition-standard);
}

.card-style:hover,
.el-card:hover {
  box-shadow: var(--md-elevation-3);
  transform: translateY(-2px);
}

/* ========================================
   Material You Input Styles
   ======================================== */
.el-input__inner {
  border-radius: var(--md-corner-extra-small) var(--md-corner-extra-small) 0 0 !important;
  border: none !important;
  border-bottom: 2px solid var(--md-outline-variant) !important;
  background: var(--md-surface-container-highest) !important;
  transition: all var(--md-transition-duration-short) var(--md-transition-standard);
}

.el-input__inner:focus {
  border-bottom-color: var(--md-theme) !important;
  background: var(--md-surface-container-high) !important;
  box-shadow: none !important;
}

/* Filled variant for specific forms */
.md-filled-input .el-input__inner {
  border-radius: var(--md-corner-medium) !important;
  border: 1px solid var(--md-outline-variant) !important;
  background: var(--md-surface) !important;
}

.md-filled-input .el-input__inner:focus {
  border-color: var(--md-theme) !important;
  box-shadow: 0 0 0 2px var(--md-theme-light) !important;
}

/* ========================================
   Material You Tag Styles
   ======================================== */
.el-tag {
  border-radius: var(--md-corner-small) !important;
  border: none !important;
  font-weight: 500;
  padding: 0 12px;
  height: 32px;
  line-height: 32px;
}

.el-tag--success {
  background: var(--md-tertiary-container) !important;
  color: var(--md-on-tertiary-container) !important;
}

.el-tag--warning {
  background: var(--md-theme-container) !important;
  color: var(--md-on-theme-container) !important;
}

.el-tag--danger {
  background: var(--md-error-container) !important;
  color: var(--md-on-error-container) !important;
}

.el-tag--info {
  background: var(--md-surface-container-high) !important;
  color: var(--md-on-surface) !important;
}

.el-tag--primary {
  background: var(--md-primary-container) !important;
  color: var(--md-on-primary-container) !important;
}

/* ========================================
   Material You Dialog Styles
   ======================================== */
.el-dialog {
  border-radius: var(--md-corner-extra-large) !important;
  box-shadow: var(--md-elevation-5) !important;
  overflow: hidden;
}

.el-dialog__header {
  padding: 24px 24px 16px !important;
  background: var(--md-surface-container-low);
}

.el-dialog__title {
  font-size: 24px !important;
  font-weight: 500 !important;
  color: var(--md-on-surface) !important;
}

.el-dialog__body {
  padding: 0 24px 24px !important;
  color: var(--md-on-surface-variant);
}

.el-dialog__footer {
  padding: 16px 24px 24px !important;
  background: var(--md-surface-container-low);
}

/* ========================================
   Material You Message Box
   ======================================== */
.el-message-box {
  border-radius: var(--md-corner-extra-large) !important;
  box-shadow: var(--md-elevation-5) !important;
  border: none !important;
  padding: 24px !important;
}

/* ========================================
   Material You Toast/Message
   ======================================== */
.el-message {
  border-radius: var(--md-corner-large) !important;
  border: none !important;
  box-shadow: var(--md-elevation-3) !important;
  padding: 12px 20px !important;
  min-width: auto !important;
}

.el-message--success {
  background: var(--md-tertiary-container) !important;
  color: var(--md-on-tertiary-container) !important;
}

.el-message--warning {
  background: var(--md-theme-container) !important;
  color: var(--md-on-theme-container) !important;
}

.el-message--error {
  background: var(--md-error-container) !important;
  color: var(--md-on-error-container) !important;
}

.el-message--info {
  background: var(--md-surface-container-high) !important;
  color: var(--md-on-surface) !important;
}

/* ========================================
   Material You Table Styles
   ======================================== */
.el-table {
  border-radius: var(--md-corner-large) !important;
  overflow: hidden;
  background: var(--md-surface) !important;
}

.el-table th.el-table__cell {
  background: var(--md-surface-container-high) !important;
  color: var(--md-on-surface) !important;
  font-weight: 500;
}

.el-table td.el-table__cell {
  border-bottom: 1px solid var(--md-outline-variant) !important;
}

.el-table--striped .el-table__body tr.el-table__row--striped td.el-table__cell {
  background: var(--md-surface-container-lowest) !important;
}

.el-table__row:hover > td.el-table__cell {
  background: var(--md-surface-container) !important;
}

/* ========================================
   Material You Pagination
   ======================================== */
.el-pagination.is-background .btn-next,
.el-pagination.is-background .btn-prev,
.el-pagination.is-background .el-pager li {
  border-radius: var(--md-corner-full) !important;
  background: var(--md-surface-container-high) !important;
  color: var(--md-on-surface) !important;
  border: none !important;
  margin: 0 4px;
  min-width: 36px;
  height: 36px;
  line-height: 36px;
  transition: all var(--md-transition-duration-short) var(--md-transition-standard);
}

.el-pagination.is-background .el-pager li:hover {
  background: var(--md-theme-light) !important;
  color: var(--md-on-theme-container) !important;
}

.el-pagination.is-background .el-pager li.active {
  background: var(--md-theme) !important;
  color: var(--md-on-theme) !important;
}

/* ========================================
   Material You Select Dropdown
   ======================================== */
.el-select-dropdown {
  border-radius: var(--md-corner-large) !important;
  border: none !important;
  box-shadow: var(--md-elevation-3) !important;
  margin-top: 8px !important;
}

.el-select-dropdown__item {
  border-radius: var(--md-corner-small);
  margin: 4px 8px;
  padding: 8px 12px !important;
  transition: all var(--md-transition-duration-short) var(--md-transition-standard);
}

.el-select-dropdown__item.hover,
.el-select-dropdown__item:hover {
  background: var(--md-surface-container-high) !important;
}

.el-select-dropdown__item.selected {
  background: var(--md-theme-light) !important;
  color: var(--md-on-theme-container) !important;
  font-weight: 500;
}

/* ========================================
   Material You Menu Styles
   ======================================== */
.el-menu {
  border: none !important;
  background: transparent !important;
}

.el-menu-item {
  border-radius: var(--md-corner-extra-large) !important;
  margin: 4px 12px !important;
  transition: all var(--md-transition-duration-short) var(--md-transition-standard);
}

.el-menu-item:hover {
  background: var(--md-surface-container-high) !important;
}

.el-menu-item.is-active {
  background: var(--md-theme-light) !important;
  color: var(--md-on-theme-container) !important;
}

/* ========================================
   Material You Checkbox & Radio
   ======================================== */
.el-checkbox__input.is-checked .el-checkbox__inner {
  background: var(--md-theme) !important;
  border-color: var(--md-theme) !important;
}

.el-radio__input.is-checked .el-radio__inner {
  background: var(--md-theme) !important;
  border-color: var(--md-theme) !important;
}

/* ========================================
   Material You Switch
   ======================================== */
.el-switch.is-checked .el-switch__core {
  background: var(--md-theme) !important;
  border-color: var(--md-theme) !important;
}

/* ========================================
   Material You Tabs
   ======================================== */
.el-tabs__item {
  border-radius: var(--md-corner-large) var(--md-corner-large) 0 0 !important;
  transition: all var(--md-transition-duration-short) var(--md-transition-standard);
}

.el-tabs__item.is-active {
  background: var(--md-theme-light) !important;
  color: var(--md-on-theme-container) !important;
}

.el-tabs__active-bar {
  background: var(--md-theme) !important;
  border-radius: 3px 3px 0 0;
  height: 3px !important;
}

/* ========================================
   Material You Scrollbar
   ======================================== */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: var(--md-surface-container);
  border-radius: var(--md-corner-full);
}

::-webkit-scrollbar-thumb {
  background: var(--md-outline-variant);
  border-radius: var(--md-corner-full);
  transition: background var(--md-transition-duration-short) var(--md-transition-standard);
}

::-webkit-scrollbar-thumb:hover {
  background: var(--md-theme);
}

/* ========================================
   Material You Loading
   ======================================== */
.el-loading-mask {
  background: rgba(255, 251, 254, 0.9) !important;
  backdrop-filter: blur(8px);
}

.el-loading-spinner .path {
  stroke: var(--md-theme) !important;
}

/* ========================================
   Ripple Effect (Material Design)
   ======================================== */
.ripple-effect {
  position: relative;
  overflow: hidden;
}

.ripple-effect::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  border-radius: 50%;
  background: rgba(103, 80, 164, 0.2);
  transform: translate(-50%, -50%);
  transition: width 0.6s var(--md-transition-standard),
              height 0.6s var(--md-transition-standard),
              opacity 0.6s var(--md-transition-standard);
  opacity: 0;
}

.ripple-effect:active::after {
  width: 300px;
  height: 300px;
  opacity: 1;
  transition: 0s;
}

/* ========================================
   Animation Utilities
   ======================================== */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes scaleIn {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(16px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in {
  animation: fadeIn var(--md-transition-duration-medium) var(--md-transition-standard);
}

.animate-scale-in {
  animation: scaleIn var(--md-transition-duration-medium) var(--md-transition-emphasized);
}

.animate-slide-in {
  animation: slideInUp var(--md-transition-duration-medium) var(--md-transition-standard);
}
</style>
