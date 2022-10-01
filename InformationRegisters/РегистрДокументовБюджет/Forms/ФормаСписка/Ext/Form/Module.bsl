﻿
&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
	Элементы.Список.Обновить();
КонецПроцедуры

Процедура ЗаполнитьНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(Бюджетный.НомерСтроки) КАК Количество,
	               |	Бюджетный.Регистратор
	               |ПОМЕСТИТЬ БюджетСвернутый
	               |ИЗ
	               |	Документ.Д_Бюджет КАК Д_Бюджет
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Бюджетный КАК Бюджетный
	               |		ПО (Бюджетный.Регистратор = Д_Бюджет.Ссылка)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Бюджетный.Регистратор
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	БюджетСвернутый.Регистратор Как Документ,
	               |	БюджетСвернутый.Количество
	               |ИЗ
	               |	БюджетСвернутый КАК БюджетСвернутый
	               |ГДЕ
	               |	БюджетСвернутый.Количество > 1000";
				   
	Выборка =  Запрос.Выполнить().Выбрать();
	НаборЗаписей = РегистрыСведений.РегистрДокументовБюджет.СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		Запись = НаборЗаписей.Добавить();
		Запись.Документ = Выборка.Документ;		
	КонецЦикла;
	НаборЗаписей.Записать(Истина);
КонецПроцедуры
