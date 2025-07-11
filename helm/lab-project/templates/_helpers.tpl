{{/* Generate a fullname for resources */}}
{{- define "lab-project.fullname" -}}
{{- printf "%s" .Release.Name -}}
{{- end -}}

{{/* Chart name */}}
{{- define "lab-project.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}} 