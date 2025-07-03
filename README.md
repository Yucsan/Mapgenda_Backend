# 🛠️ Mapgenda Backend

API REST desarrollada en Java con Spring Boot, diseñada para servir como backend de la aplicación móvil **Mapgenda**. Se encarga de la autenticación de usuarios, el almacenamiento seguro en la nube, la gestión de contenidos multimedia y la sincronización eficiente de datos entre el cliente móvil y los servicios de terceros como **Google Sign-In** y **Cloudinary**.

---

## 🌐 Arquitectura General

<img src="assets/estructura.jpg" width="700"/>

---

## ✨ Funcionalidades Principales

- Registro y autenticación con **Google Sign-In**
- Gestión de sesiones JWT
- Almacenamiento y carga de contenido multimedia vía **Cloudinary**
- Persistencia de datos con PostgreSQL + JPA
- API RESTful para la sincronización con la app móvil
- Seguridad robusta con **Spring Security**

---

## ⚙️ Stack Tecnológico

| Componente        | Tecnología                                  |
|-------------------|---------------------------------------------|
| **Framework**     | Spring Boot 3.4.4                           |
| **Lenguaje**      | Java 21                                     |
| **Build Tool**    | Maven                                       |
| **Base de Datos** | PostgreSQL + Spring Data JPA               |
| **Seguridad**     | Spring Security + JWT                      |
| **Autenticación** | Google Sign-In API                         |
| **DTO ↔ Entidades**| MapStruct                                  |
| **Boilerplate**   | Lombok                                      |
| **JSON Mapper**   | Jackson                                     |

---

## 🖼️ Visual Tech Stack

<img src="assets/tecno_back.jpg" width="700"/>

---

## 🚀 Instalación y Ejecución

### 🔧 Requisitos Previos

- JDK 21 instalado
- PostgreSQL en ejecución con base de datos creada
- Maven 3.8+ instalado

### 📥 Clonar el repositorio

```bash
git clone https://github.com/Yucsan/Mapgenda_Backend.git
cd Mapgenda_Backend
