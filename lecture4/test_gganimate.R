
### 2. Case study

#### 2.1 Controls

```{r}
lm(lEarnings ~ Hours + sqHours + Sex, asec)
```

--
  
  ```{r}
asec <- asec %>% 
  group_by(Sex) %>% 
  mutate(d_lEarnings = lEarnings - mean(lEarnings), 
         d_Hours = Hours - mean(Hours), 
         d_sqHours = sqHours - mean(sqHours)) %>%
  ungroup()

lm(d_lEarnings ~ d_Hours + d_sqHours, asec)
```

---
  
  ### 2. Control variables
  
  #### 2.2. Discrete
  
  <ul>
  <li>We can <b>obtain</b> this common <b>slope</b> by:</li>
  <ol>
  <li><b>Demeaning</b> earnings and hours by group</li>
  <li><b>Regressing</b> the demeaned earnings on the hours</li>
  </ol>
  </ul>
  <!-- -->
  ```{r, echo = F, fig.width = 7, fig.height = 4, out.width = "60%"}
#######################################
# AJOUTER UN MARQUEUR POUR LA MOYENNE #
#######################################

# Animation
##################
library(gganimate)
library(transformr)
coefs <- summary(lm(lEarnings ~ poly(Hours, 2, raw=TRUE) + Male, asec))$coefficients
anim_asec <- asec %>%
  mutate(time = 0,
         fit = ifelse(Sex == "Male", 
                      coefs[1, 1] + coefs[4, 1] + (coefs[2, 1] * Hours) + (coefs[3, 1] * (Hours^2)),
                      coefs[1, 1] + (coefs[2, 1] * Hours) + (coefs[3, 1] * Hours^2)))

for (i in 1:10) {
  
  temp_asec <- asec %>%
    group_by(Sex) %>%
    mutate(Hours = ifelse(Sex == "Male", Hours - (i/10) * mean(Hours), Hours))
  
  
  anim_asec <- anim_asec %>%
    bind_rows(temp_asec %>%
                mutate(time = i,
                       fit = ifelse(Sex == "Male", 
                                    coefs[1, 1] + coefs[4, 1] + (coefs[2, 1] * (Hours - (i/10) * mean(asec[asec$Sex=="Male", "Hours"]))) + (coefs[3, 1] * (Hours^2 - (i/10) * (mean(asec[asec$Sex=="Male", "Hours"]^2)))),
                                    coefs[1, 1] + (coefs[2, 1] * Hours) + (coefs[3, 1] * Hours^2))))
} 

asec2 <- asec %>%
  group_by(Sex) %>%
  mutate(Hours = ifelse(Sex == "Male", Hours - mean(Hours), Hours))

for (j in 1:10) {
  
  temp_asec <- asec2 %>%
    group_by(Sex) %>%
    mutate(lEarnings = ifelse(Sex == "Male", lEarnings - (j/10) * mean(lEarnings), lEarnings))
  
  anim_asec <- anim_asec %>%
    bind_rows(temp_asec %>%
                mutate(time = j + 10,
                       fit = ifelse(Sex == "Male", 
                                    coefs[1, 1] + coefs[4, 1] + (coefs[2, 1] * (Hours - mean(asec[asec$Sex=="Male", "Hours"]))) + (coefs[3, 1] * (Hours^2 - (mean(asec[asec$Sex=="Male", "Hours"]^2)))) - (j/10) * mean(asec[asec$Sex=="Male", "lEarnings"]),
                                    coefs[1, 1] + (coefs[2, 1] * Hours) + (coefs[3, 1] * Hours^2))))
} 

asec3 <- asec2 %>%
  group_by(Sex) %>%
  mutate(lEarnings = ifelse(Sex == "Male", lEarnings - mean(lEarnings), lEarnings))

for (j in 1:10) {
  
  temp_asec <- asec3 %>%
    group_by(Sex) %>%
    mutate(Hours = ifelse(Sex == "Female", Hours - (j/10) * mean(Hours), Hours))
  
  anim_asec <- anim_asec %>%
    bind_rows(temp_asec %>%
                mutate(time = j + 20,
                       fit = ifelse(Sex == "Male", 
                                    coefs[1, 1] + coefs[4, 1] + (coefs[2, 1] * (Hours - mean(asec[asec$Sex=="Male", "Hours"]))) + (coefs[3, 1] * (Hours^2 - (mean(asec[asec$Sex=="Male", "Hours"]^2)))) - mean(asec[asec$Sex=="Male", "lEarnings"]),
                                    coefs[1, 1] + (coefs[2, 1] * (Hours - (j/10) * mean(asec[asec$Sex=="Female", "Hours"]))) + (coefs[3, 1] * (coefs[3, 1] * (Hours^2 - (j/10) * (mean(asec[asec$Sex=="Female", "Hours"]^2))))))))
} 

asec4 <- asec3 %>%
  group_by(Sex) %>%
  mutate(Hours = ifelse(Sex == "Female", Hours - mean(Hours), Hours))

for (j in 1:10) {
  
  temp_asec <- asec4 %>%
    group_by(Sex) %>%
    mutate(lEarnings = ifelse(Sex == "Female", lEarnings - (j/10) * mean(lEarnings), lEarnings))
  
  anim_asec <- anim_asec %>%
    bind_rows(temp_asec %>%
                mutate(time = j + 30,
                       fit = ifelse(Sex == "Male", 
                                    coefs[1, 1] + coefs[4, 1] + (coefs[2, 1] * (Hours - mean(asec[asec$Sex=="Male", "Hours"]))) + (coefs[3, 1] * (Hours^2 - (mean(asec[asec$Sex=="Male", "Hours"]^2)))) - mean(asec[asec$Sex=="Male", "lEarnings"]),
                                    coefs[1, 1] + (coefs[2, 1] * (Hours - mean(asec[asec$Sex=="Female", "Hours"]))) + (coefs[3, 1] * (Hours^2 - (mean(asec[asec$Sex=="Female", "Hours"]^2)))) - (j/10) * mean(asec[asec$Sex=="Female", "lEarnings"]))))
} 


limits <- asec %>%
  group_by(Sex) %>%
  summarise(earn = min(lEarnings) - mean(lEarnings),
            hours = min(Hours) - mean(Hours)) %>%
  ungroup() %>%
  summarise(earn = min(earn), hours = min(hours))

anim_asec <- anim_asec %>% 
  #filter(time > 0) %>%
  select(Sex, lEarnings, Hours, fit, time)

test <- ggplot(anim_asec, aes(x = Hours, y = lEarnings, color = Sex)) + 
  # 0xy
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  # Data
  geom_point(alpha = .1) +
  geom_line(aes(y = fit)) + 
  # Scales
  scale_y_continuous(limits = c(limits$earn, 15)) +
  scale_x_continuous(limits = c(limits$hours, max(asec$Hours))) +
  transition_manual(as.factor(time))

animation <- animate(test, nframes = 40, fps = 20, end_pause = 10, height = 800, width = 1400, res = 200)
animation
```

---
  
  ### 2. Control variables
  
  #### 2.2. Discrete
  
  <ul>
  <li>Note that once we <b>control</b> for third variable</li>
  <ol>
  <li>As we move along the x axis, this <b>third variable remains constant</b></li>
  <li>Here, as the number of <b>hours increases</b> the probability to be a <b>male does not</b> increase anymore</li>
  </ol>
  </ul>
  
  
  ```{r, echo = F, fig.width = 7, fig.height = 4, out.width = "60%"}
temp_dat <- asec %>%
  group_by(Sex) %>%
  mutate(lEarnings = lEarnings - mean(lEarnings),
         Hours = Hours - mean(Hours))

coefs_s <- summary(lm(lEarnings ~ poly(Hours, 2, raw=TRUE) + Sex, temp_dat))$coefficients

ggplot(temp_dat %>% mutate(fit = (Hours * coefs_s[2, 1]) + (Hours^2 * coefs_s[3, 1]) + coefs_s[1, 1],
                           fit = ifelse(Sex == "Male", fit + coefs_s[4, 1], fit)), 
       aes(x = Hours, y = lEarnings, color = Sex)) + 
  geom_point(alpha = .1) +
  geom_line(aes(y = fit), alpha = .4) +
  geom_vline(xintercept = 0, linetype = "dashed", alpha = .4) +
  geom_hline(yintercept = 0, linetype = "dashed", alpha = .4)
```

---
  