﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	// Вставить содержимое обработчика.
	// ПараметрыФормы = Новый Структура("", );
	// ОткрытьФорму("ОбщаяФорма.", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	ОткрытьФорму("РегистрБухгалтерии.Бюджетный.Форма.ФормаПроводок", Новый Структура("Регистратор, ВыбДок", ПараметрКоманды, ПараметрКоманды),, ПараметрКоманды);
	
КонецПроцедуры
