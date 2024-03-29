﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Надпись1.Заголовок = СтрЗаменить(Элементы.Надпись1.Заголовок, "%Комп",         ИмяКомпьютера());
	Элементы.Надпись1.Заголовок = СтрЗаменить(Элементы.Надпись1.Заголовок, "%Пользователь", сабОбщегоНазначения.ТекущийПользователь());
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДаНаСервере()
	
	МенеджерЗаписи = РегистрыСведений.КомпьютерыПользователей.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Пользователь = сабОбщегоНазначения.ТекущийПользователь();
	МенеджерЗаписи.Компьютер    = ИмяКомпьютера();
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Основной = Истина;
	Иначе
		МенеджерЗаписи.Пользователь = сабОбщегоНазначения.ТекущийПользователь();
		МенеджерЗаписи.Компьютер    = ИмяКомпьютера();
		МенеджерЗаписи.Основной = Истина;
	КонецЕсли;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура Да(Команда)
	ДаНаСервере();
	Закрыть();
КонецПроцедуры
