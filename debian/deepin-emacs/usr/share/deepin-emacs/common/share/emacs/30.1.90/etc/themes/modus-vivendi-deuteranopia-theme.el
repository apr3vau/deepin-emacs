;;; modus-vivendi-deuteranopia-theme.el --- Deuteranopia-optimized theme with a black background -*- lexical-binding:t -*-

;; Copyright (C) 2019-2025 Free Software Foundation, Inc.

;; Author: Protesilaos Stavrou <info@protesilaos.com>
;; Maintainer: Protesilaos Stavrou <info@protesilaos.com>
;; URL: https://github.com/protesilaos/modus-themes
;; Keywords: faces, theme, accessibility

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; The Modus themes conform with the highest standard for
;; color-contrast accessibility between background and foreground
;; values (WCAG AAA).  Please refer to the official Info manual for
;; further documentation (distributed with the themes, or available
;; at: <https://protesilaos.com/emacs/modus-themes>).

;;; Code:



(eval-and-compile
  (unless (and (fboundp 'require-theme)
               load-file-name
               (equal (file-name-directory load-file-name)
                      (expand-file-name "themes/" data-directory))
               (require-theme 'modus-themes t))
    (require 'modus-themes))

;;;###theme-autoload
  (deftheme modus-vivendi-deuteranopia
    "Deuteranopia-optimized theme with a black background.
This variant is optimized for users with red-green color
deficiency (deuteranopia).  It conforms with the highest
legibility standard for color contrast between background and
foreground in any given piece of text, which corresponds to a
minimum contrast in relative luminance of 7:1 (WCAG AAA
standard)."
    :background-mode 'dark
    :kind 'color-scheme
    :family 'modus)

  (defconst modus-vivendi-deuteranopia-palette
    '(
;;; Basic values

      (bg-main          "#000000")
      (bg-dim           "#1e1e1e")
      (fg-main          "#ffffff")
      (fg-dim           "#989898")
      (fg-alt           "#c6daff")
      (bg-active        "#535353")
      (bg-inactive      "#303030")
      (border           "#646464")

;;; Common accent foregrounds

      (red             "#ff5f59")
      (red-warmer      "#ff6b55")
      (red-cooler      "#ff7f9f")
      (red-faint       "#ff9580")
      (red-intense     "#ff5f5f")
      (green           "#44bc44")
      (green-warmer    "#70b900")
      (green-cooler    "#00c06f")
      (green-faint     "#88ca9f")
      (green-intense   "#44df44")
      (yellow          "#cabf00")
      (yellow-warmer   "#ffa00f")
      (yellow-cooler   "#d8af7a")
      (yellow-faint    "#d2b580")
      (yellow-intense  "#efef00")
      (blue            "#2fafff")
      (blue-warmer     "#79a8ff")
      (blue-cooler     "#00bcff")
      (blue-faint      "#82b0ec")
      (blue-intense    "#338fff")
      (magenta         "#feacd0")
      (magenta-warmer  "#f78fe7")
      (magenta-cooler  "#b6a0ff")
      (magenta-faint   "#caa6df")
      (magenta-intense "#ff66ff")
      (cyan            "#00d3d0")
      (cyan-warmer     "#4ae2f0")
      (cyan-cooler     "#6ae4b9")
      (cyan-faint      "#9ac8e0")
      (cyan-intense    "#00eff0")

;;; Uncommon accent foregrounds

      (rust       "#db7b5f")
      (gold       "#c0965b")
      (olive      "#9cbd6f")
      (slate      "#76afbf")
      (indigo     "#9099d9")
      (maroon     "#cf7fa7")
      (pink       "#d09dc0")

;;; Common accent backgrounds

      (bg-red-intense     "#9d1f1f")
      (bg-green-intense   "#2f822f")
      (bg-yellow-intense  "#7a6100")
      (bg-blue-intense    "#1640b0")
      (bg-magenta-intense "#7030af")
      (bg-cyan-intense    "#2266ae")

      (bg-red-subtle      "#620f2a")
      (bg-green-subtle    "#00422a")
      (bg-yellow-subtle   "#4a4000")
      (bg-blue-subtle     "#242679")
      (bg-magenta-subtle  "#552f5f")
      (bg-cyan-subtle     "#004065")

      (bg-red-nuanced     "#3a0c14")
      (bg-green-nuanced   "#092f1f")
      (bg-yellow-nuanced  "#381d0f")
      (bg-blue-nuanced    "#12154a")
      (bg-magenta-nuanced "#2f0c3f")
      (bg-cyan-nuanced    "#042837")

;;; Uncommon accent backgrounds

      (bg-ochre    "#442c2f")
      (bg-lavender "#38325c")
      (bg-sage     "#0f3d30")

;;; Graphs

      (bg-graph-red-0     "#bf6000")
      (bg-graph-red-1     "#733500")
      (bg-graph-green-0   "#6fbf8f")
      (bg-graph-green-1   "#2f5f4f")
      (bg-graph-yellow-0  "#c1c00a")
      (bg-graph-yellow-1  "#7f6640")
      (bg-graph-blue-0    "#0f90ef")
      (bg-graph-blue-1    "#1f2f8f")
      (bg-graph-magenta-0 "#7f7f8e")
      (bg-graph-magenta-1 "#4f4f5f")
      (bg-graph-cyan-0    "#376f9a")
      (bg-graph-cyan-1    "#00404f")

;;; Special purpose

      (bg-completion       "#2f447f")
      (bg-hover            "#45605e")
      (bg-hover-secondary  "#654a39")
      (bg-hl-line          "#2f3849")
      (bg-region           "#5a5a5a")
      (fg-region           "#ffffff")

      (bg-char-0 "#0050af")
      (bg-char-1 "#7f1f7f")
      (bg-char-2 "#625a00")

      (bg-mode-line-active        "#2a2a6a")
      (fg-mode-line-active        "#f0f0f0")
      (border-mode-line-active    "#8080a7")
      (bg-mode-line-inactive      "#2d2d2d")
      (fg-mode-line-inactive      "#969696")
      (border-mode-line-inactive  "#606060")

      (modeline-err     "#e5bf00")
      (modeline-warning "#c0cf35")
      (modeline-info    "#abeadf")

      (bg-tab-bar      "#313131")
      (bg-tab-current  "#000000")
      (bg-tab-other    "#545454")

;;; Diffs

      (bg-added           "#003066")
      (bg-added-faint     "#001a4f")
      (bg-added-refine    "#0f4a77")
      (bg-added-fringe    "#006fff")
      (fg-added           "#c4d5ff")
      (fg-added-intense   "#8080ff")

      (bg-changed         "#2f123f")
      (bg-changed-faint   "#1f022f")
      (bg-changed-refine  "#3f325f")
      (bg-changed-fringe  "#7f55a0")
      (fg-changed         "#e3cfff")
      (fg-changed-intense "#cf9fe2")

      (bg-removed         "#3d3d00")
      (bg-removed-faint   "#281f00")
      (bg-removed-refine  "#555500")
      (bg-removed-fringe  "#d0c03f")
      (fg-removed         "#d4d48f")
      (fg-removed-intense "#d0b05f")

      (bg-diff-context    "#1a1a1a")

;;; Paren match

      (bg-paren-match        "#2f7f9f")
      (fg-paren-match        fg-main)
      (bg-paren-expression   "#453040")
      (underline-paren-match unspecified)

;;; Mappings

;;;; General mappings

      (fringe bg-dim)
      (cursor yellow-intense)

      (keybind blue-cooler)
      (name blue-cooler)
      (identifier yellow-faint)

      (err yellow-warmer)
      (warning yellow)
      (info blue)

      (underline-err yellow-intense)
      (underline-warning magenta-faint)
      (underline-note cyan)

      (bg-prominent-err bg-yellow-intense)
      (fg-prominent-err fg-main)
      (bg-prominent-warning bg-magenta-intense)
      (fg-prominent-warning fg-main)
      (bg-prominent-note bg-cyan-intense)
      (fg-prominent-note fg-main)

      (bg-active-argument bg-yellow-nuanced)
      (fg-active-argument yellow-warmer)
      (bg-active-value bg-blue-nuanced)
      (fg-active-value blue-warmer)

;;;; Code mappings

      (builtin magenta-warmer)
      (comment yellow-cooler)
      (constant blue-cooler)
      (docstring cyan-faint)
      (docmarkup magenta-faint)
      (fnname magenta)
      (keyword magenta-cooler)
      (preprocessor red-cooler)
      (string blue-warmer)
      (type cyan-cooler)
      (variable cyan)
      (rx-construct yellow-cooler)
      (rx-backslash blue-cooler)

;;;; Accent mappings

      (accent-0 blue-cooler)
      (accent-1 yellow)
      (accent-2 cyan-cooler)
      (accent-3 magenta-warmer)

;;;; Button mappings

      (fg-button-active fg-main)
      (fg-button-inactive fg-dim)
      (bg-button-active bg-active)
      (bg-button-inactive bg-dim)

;;;; Completion mappings

      (fg-completion-match-0 blue-cooler)
      (fg-completion-match-1 yellow)
      (fg-completion-match-2 cyan-cooler)
      (fg-completion-match-3 magenta-warmer)
      (bg-completion-match-0 unspecified)
      (bg-completion-match-1 unspecified)
      (bg-completion-match-2 unspecified)
      (bg-completion-match-3 unspecified)

;;;; Date mappings

      (date-common cyan)
      (date-deadline yellow-warmer)
      (date-event fg-alt)
      (date-holiday yellow-warmer)
      (date-holiday-other blue)
      (date-now fg-main)
      (date-range fg-alt)
      (date-scheduled yellow-cooler)
      (date-weekday cyan)
      (date-weekend yellow-faint)

;;;; Line number mappings

      (fg-line-number-inactive fg-dim)
      (fg-line-number-active fg-main)
      (bg-line-number-inactive bg-dim)
      (bg-line-number-active bg-active)

;;;; Link mappings

      (fg-link blue-warmer)
      (bg-link unspecified)
      (underline-link blue-warmer)

      (fg-link-symbolic cyan)
      (bg-link-symbolic unspecified)
      (underline-link-symbolic cyan)

      (fg-link-visited yellow-faint)
      (bg-link-visited unspecified)
      (underline-link-visited yellow-faint)

;;;; Mail mappings

      (mail-cite-0 blue-warmer)
      (mail-cite-1 yellow-cooler)
      (mail-cite-2 cyan-faint)
      (mail-cite-3 yellow)
      (mail-part blue)
      (mail-recipient blue)
      (mail-subject yellow-warmer)
      (mail-other cyan-faint)

;;;; Mark mappings

      (bg-mark-delete bg-yellow-subtle)
      (fg-mark-delete yellow)
      (bg-mark-select bg-cyan-subtle)
      (fg-mark-select cyan)
      (bg-mark-other bg-magenta-subtle)
      (fg-mark-other magenta-warmer)

;;;; Prompt mappings

      (fg-prompt blue)
      (bg-prompt unspecified)

;;;; Prose mappings

      (bg-prose-block-delimiter bg-dim)
      (fg-prose-block-delimiter fg-dim)
      (bg-prose-block-contents bg-dim)

      (bg-prose-code unspecified)
      (fg-prose-code cyan-cooler)

      (bg-prose-macro unspecified)
      (fg-prose-macro magenta-cooler)

      (bg-prose-verbatim unspecified)
      (fg-prose-verbatim magenta-warmer)

      (prose-done blue)
      (prose-todo yellow-warmer)

      (prose-metadata fg-dim)
      (prose-metadata-value fg-alt)

      (prose-table fg-alt)
      (prose-table-formula yellow-warmer)

      (prose-tag magenta-faint)

;;;; Rainbow mappings

      (rainbow-0 yellow-warmer)
      (rainbow-1 blue)
      (rainbow-2 yellow-cooler)
      (rainbow-3 blue-warmer)
      (rainbow-4 yellow)
      (rainbow-5 cyan-warmer)
      (rainbow-6 yellow-faint)
      (rainbow-7 blue-faint)
      (rainbow-8 magenta-faint)

;;;; Search mappings

      (bg-search-current bg-yellow-intense)
      (bg-search-lazy bg-blue-intense)
      (bg-search-replace bg-magenta-intense)

      (bg-search-rx-group-0 bg-cyan-intense)
      (bg-search-rx-group-1 bg-magenta-intense)
      (bg-search-rx-group-2 bg-blue-subtle)
      (bg-search-rx-group-3 bg-yellow-subtle)

;;;; Space mappings

      (bg-space unspecified)
      (fg-space border)
      (bg-space-err bg-yellow-intense)

;;;; Terminal mappings

      (bg-term-black           "#000000")
      (fg-term-black           "#000000")
      (bg-term-black-bright    "#595959")
      (fg-term-black-bright    "#595959")

      (bg-term-red             red)
      (fg-term-red             red)
      (bg-term-red-bright      red-warmer)
      (fg-term-red-bright      red-warmer)

      (bg-term-green           green)
      (fg-term-green           green)
      (bg-term-green-bright    green-cooler)
      (fg-term-green-bright    green-cooler)

      (bg-term-yellow          yellow)
      (fg-term-yellow          yellow)
      (bg-term-yellow-bright   yellow-warmer)
      (fg-term-yellow-bright   yellow-warmer)

      (bg-term-blue            blue)
      (fg-term-blue            blue)
      (bg-term-blue-bright     blue-warmer)
      (fg-term-blue-bright     blue-warmer)

      (bg-term-magenta         magenta)
      (fg-term-magenta         magenta)
      (bg-term-magenta-bright  magenta-cooler)
      (fg-term-magenta-bright  magenta-cooler)

      (bg-term-cyan            cyan)
      (fg-term-cyan            cyan)
      (bg-term-cyan-bright     cyan-cooler)
      (fg-term-cyan-bright     cyan-cooler)

      (bg-term-white           "#a6a6a6")
      (fg-term-white           "#a6a6a6")
      (bg-term-white-bright    "#ffffff")
      (fg-term-white-bright    "#ffffff")

;;;; Heading mappings

      (fg-heading-0 cyan-cooler)
      (fg-heading-1 fg-main)
      (fg-heading-2 yellow-faint)
      (fg-heading-3 blue-faint)
      (fg-heading-4 magenta)
      (fg-heading-5 green-faint)
      (fg-heading-6 red-faint)
      (fg-heading-7 cyan-faint)
      (fg-heading-8 fg-dim)

      (bg-heading-0 unspecified)
      (bg-heading-1 unspecified)
      (bg-heading-2 unspecified)
      (bg-heading-3 unspecified)
      (bg-heading-4 unspecified)
      (bg-heading-5 unspecified)
      (bg-heading-6 unspecified)
      (bg-heading-7 unspecified)
      (bg-heading-8 unspecified)

      (overline-heading-0 unspecified)
      (overline-heading-1 unspecified)
      (overline-heading-2 unspecified)
      (overline-heading-3 unspecified)
      (overline-heading-4 unspecified)
      (overline-heading-5 unspecified)
      (overline-heading-6 unspecified)
      (overline-heading-7 unspecified)
      (overline-heading-8 unspecified))
    "The entire palette of the `modus-vivendi-deuteranopia' theme.

Named colors have the form (COLOR-NAME HEX-VALUE) with the former
as a symbol and the latter as a string.

Semantic color mappings have the form (MAPPING-NAME COLOR-NAME)
with both as symbols.  The latter is a named color that already
exists in the palette and is associated with a HEX-VALUE.")

  (defcustom modus-vivendi-deuteranopia-palette-overrides nil
    "Overrides for `modus-vivendi-deuteranopia-palette'.

Mirror the elements of the aforementioned palette, overriding
their value.

For overrides that are shared across all of the Modus themes,
refer to `modus-themes-common-palette-overrides'.

Theme-specific overrides take precedence over shared overrides.
The idea of common overrides is to change semantic color
mappings, such as to make the cursor red.  Wherea theme-specific
overrides can also be used to change the value of a named color,
such as what hexadecimal RGB value the red-warmer symbol
represents."
    :group 'modus-themes
    :package-version '(modus-themes . "4.0.0")
    :version "30.1"
    :type '(repeat (list symbol (choice symbol string)))
    :set #'modus-themes--set-option
    :initialize #'custom-initialize-default
    :link '(info-link "(modus-themes) Palette overrides"))

  (modus-themes-theme modus-vivendi-deuteranopia
                      modus-vivendi-deuteranopia-palette
                      modus-vivendi-deuteranopia-palette-overrides)

  (provide-theme 'modus-vivendi-deuteranopia))

;;; modus-vivendi-deuteranopia-theme.el ends here
