#!/bin/bash

# Function untuk menampilkan pesan help
show_help() {
    echo "Usage: $0 [--init|--start]"
    echo "  --init    : Menjalankan skrip untuk inisialisasi."
    echo "  --start   : Menjalankan skrip untuk memulai dengan mencetak 'Hello, World!'."
    exit 1
}


# Cek jumlah argumen
if [ "$#" -eq 0 ]; then
    show_help
fi

# Nama folder hasil clone
clone_folder="multiprocessing_video_source_modul"

# Cek argumen
while [ "$#" -gt 0 ]; do
    case "$1" in
        --init )
            # Tentukan URL repositori Git
            repo_url="https://github.com/PPI-Capstone-Project/multiprocessing_video_source_modul.git"

            
            # Lakukan git clone
            git clone -b dev "$repo_url"

            # Periksa apakah operasi git clone berhasil
            if [ $? -eq 0 ]; then
                echo "Git clone berhasil. Repositori tersedia"

                # Pindah ke direktori hasil clone atau yang sudah ada
                cd "$clone_folder" || exit

                # Install dependensi Python dengan pip (gantilah dengan nama file requirements.txt jika perlu)
                source "${pwd}/$clone_folder/bin/activate"
                
                if [ -f requirements.txt ]; then
                    pip install -r requirements.txt
                    echo "Instalasi dependensi Python berhasil."

                    env_file=".env"

                    # Cek apakah file .env sudah ada
                    if [ -f "$env_file" ]; then
                        echo "File $env_file sudah ada. Tidak dapat membuat file baru."
                        exit 1
                    fi

                    # Meminta pengguna untuk memasukkan nilai MQTT_PUB_TOPIC
                    read -p "Masukkan nilai untuk MQTT_PUB_TOPIC: " MQTT_PUB_TOPIC

                    # Meminta pengguna untuk memasukkan nilai MQTT_SUB_TOPIC
                    read -p "Masukkan nilai untuk MQTT_SUB_TOPIC: " MQTT_SUB_TOPIC

                    # Meminta pengguna untuk memasukkan nilai EDGE TOKEN
                    read -p "Masukkan nilai untuk EDGE_ACCESS_TOKEN: " EDGE_ACCESS_TOKEN

                    # Isi file .env dengan parameter yang diberikan
                    cat <<EOL > "$env_file"
                    SMARTCUBE_API_URL=https://smartcube-api-stg-sa6pbxqxca-de.a.run.app
                    # SMARTCUBE_API_URL=http://localhost:3000

                    EDGE_ACCESS_TOKEN=$EDGE_ACCESS_TOKEN
                    BREAK_TIME_WHEN_OBJECT_DETECTED=15

                    MQTT_HOST="f1096f5d.ala.asia-southeast1.emqxsl.com"
                    MQTT_PORT="8883"
                    MQTT_CA_CERT="mqtt-ssl.crt"
                    MQTT_USERNAME="zoc"
                    MQTT_PASSWORD="zocc"
                    MQTT_PUB_TOPIC="$MQTT_PUB_TOPIC"
                    MQTT_SUB_TOPIC="$MQTT_SUB_TOPIC"
EOL

                    echo "File $env_file berhasil dibuat dengan MQTT_PUB_TOPIC=$MQTT_PUB_TOPIC dan MQTT_SUB_TOPIC=$MQTT_SUB_TOPIC."

                else
                    echo "Tidak ada file requirements.txt ditemukan. Tidak ada instalasi dependensi Python yang dilakukan."
                fi

            else
                echo "Git clone gagal. Pastikan URL repositori benar dan Anda memiliki izin yang cukup."
            fi
            exit 0
            ;;
            
            --start )
		    # Menambahkan opsi untuk memulai dengan mencetak "Hello, World!"
		    cd $clone_folder
		    
		    source "$(pwd)/bin/activate"
		     
		    python app.py
            exit 0
            ;;
        * )
            show_help
            ;;
    esac
done

