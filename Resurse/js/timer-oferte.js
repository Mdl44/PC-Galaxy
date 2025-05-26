class TimerOferte {
    constructor() {
        this.interval = null;
        this.audioContext = null;
        this.timerEl = null;
        this.finalizare = null;
        
        this.initAudio();
    }

    initAudio() {
        try {
            this.audioContext = new (window.AudioContext || window.webkitAudioContext)();
        } catch (e) {
            console.log('Audio nu este disponibil');
        }
    }

    playTick() {
        if (!this.audioContext) return;
        try {
            const oscillator = this.audioContext.createOscillator();
            const gainNode = this.audioContext.createGain();
            
            oscillator.connect(gainNode);
            gainNode.connect(this.audioContext.destination);
            
            oscillator.frequency.value = 1000;
            oscillator.type = 'square';
            
            gainNode.gain.setValueAtTime(0.1, this.audioContext.currentTime);
            gainNode.gain.exponentialRampToValueAtTime(0.01, this.audioContext.currentTime + 0.1);
            
            oscillator.start(this.audioContext.currentTime);
            oscillator.stop(this.audioContext.currentTime + 0.1);
        } catch (e) {
            console.log('Eroare playTick:', e);
        }
    }

    playAlarm() {
        if (!this.audioContext) return;
        try {
            const oscillator = this.audioContext.createOscillator();
            const gainNode = this.audioContext.createGain();
            
            oscillator.connect(gainNode);
            gainNode.connect(this.audioContext.destination);
            
            oscillator.frequency.value = 400;
            oscillator.type = 'sine';
            
            gainNode.gain.setValueAtTime(0.2, this.audioContext.currentTime);
            gainNode.gain.exponentialRampToValueAtTime(0.01, this.audioContext.currentTime + 0.5);
            
            oscillator.start(this.audioContext.currentTime);
            oscillator.stop(this.audioContext.currentTime + 0.5);
        } catch (e) {
            console.log('Eroare playAlarm:', e);
        }
    }

    updateTimer() {
        const now = new Date();
        const diff = Math.max(0, this.finalizare - now);

        const sec = Math.floor((diff / 1000) % 60);
        const min = Math.floor((diff / 1000 / 60) % 60);
        const hrs = Math.floor(diff / (1000 * 60 * 60));

        if (this.timerEl) {
            this.timerEl.classList.remove("urgent", "warning");
            this.timerEl.style.color = '';
            this.timerEl.style.fontSize = '';
            this.timerEl.style.animation = '';
            
            if (diff > 10000) {
                this.timerEl.textContent = `${hrs}h ${min}m ${sec}s`;
            } else if (diff > 0) {
                this.timerEl.classList.add("urgent");
                this.timerEl.textContent = `🚨 ${sec}s 🚨`;
                this.timerEl.style.color = '#ff4757';
                this.timerEl.style.fontSize = '1.8rem';
                this.timerEl.style.fontWeight = 'bold';
                this.timerEl.style.animation = 'urgentPulse 0.5s ease-in-out infinite alternate';

                this.playTick();
                
                const ofertaDiv = document.querySelector('.oferta');
                if (ofertaDiv) {
                    ofertaDiv.style.borderColor = '#ff4757';
                    ofertaDiv.style.boxShadow = '0 0 20px rgba(255, 71, 87, 0.6)';
                }
            } else {
                this.timerEl.textContent = "⏰ EXPIRAT!";
                this.timerEl.style.color = '#ff6b6b';
                this.playAlarm();
                clearInterval(this.interval);
                
                setTimeout(() => this.incarcaOfertaNoua(), 3000);
            }
        }
    }

    incarcaOfertaNoua() {
        console.log('Se reîncarcă pagina pentru noua ofertă...');
        
        const ofertaContainer = document.querySelector('.oferta-container');
        if (ofertaContainer) {
            ofertaContainer.innerHTML = `
                <div class="oferta oferta-indisponibila">
                    <div class="oferta-header">
                        <span class="emoji">🔄</span>
                        <h2>Se generează o nouă ofertă</h2>
                    </div>
                    <p>Vă rugăm să așteptați...</p>
                    <div style="text-align: center; margin: 1rem 0;">
                        <div style="display: inline-block; width: 40px; height: 40px; border: 4px solid rgba(255,255,255,0.3); border-top: 4px solid var(--color-accent-light); border-radius: 50%; animation: spin 1s linear infinite;"></div>
                    </div>
                </div>
            `;
        }
        
        setTimeout(() => {
            window.location.reload();
        }, 2000);
    }

    start(dataFinalizare) {
        this.finalizare = new Date(dataFinalizare);
        this.timerEl = document.getElementById("timer");
        
        if (this.timerEl) {
            this.interval = setInterval(() => this.updateTimer(), 1000);
            this.updateTimer();
        }
    }

    stop() {
        if (this.interval) {
            clearInterval(this.interval);
            this.interval = null;
        }
    }
}

window.TimerOferte = TimerOferte;